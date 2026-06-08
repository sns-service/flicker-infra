# ============ VPC ============
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

# ============ Internet Gateway ============
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-igw"
  })
}

# ============ Public Subnets ============
resource "aws_subnet" "public" {
  count = length(var.azs) # AZ (가용영역) 개수

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-${var.azs[count.index]}"
    Tier = "public"
  })
}

# ============ Private Subnets ============
resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-${var.azs[count.index]}"
    Tier = "private"
  })
}

# ============ EIP for NAT Gateway ============
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-eip-${count.index}"
  })

  depends_on = [aws_internet_gateway.this]
}

# ============ NAT Gateway ============
# Private Subnet 2개가 외부 인터넷으로 나갈 떈 Public AZ-a 에 있는 NAT Gateway를 거쳐서 일방통행으로 나가도록.
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  # index가 0이므로 무조건 '첫 번째 Public 서브넷'(Public AZ-a)에 NAT을 설치한다.
  subnet_id     = aws_subnet.public[count.index].id  # public subnet에 NAT 위치

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-${count.index}"
  })

  depends_on = [aws_internet_gateway.this]
}

# ============ Public Route Table ============
# 1. 지도 만들기 (Route table)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # 나침반 설정: 0.0.0.0/0 (모든 외부 인터넷)으로 갈 때는,
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id  # 👈 Internet Gateway(대문)으로 가라.
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-rt-public"
  })
}

# 2. 만든 지도(Route table)를 Public 서브넷들에게 쥐여주기
resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============ Private Route Tables ============
resource "aws_route_table" "private" {
  # single_nat 모드면 RT 1개, 아니면 AZ마다 1개
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 1

  vpc_id = aws_vpc.this.id

  # 만약 NAT 게이트웨이를 쓴다면(true) 아래 이정표 규칙을 지도에 그려넣어라
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      # 모든 외부 인터넷으로 나갈 땐, 아까 만든 NAT GW로 나가라.
      nat_gateway_id = aws_nat_gateway.this[count.index].id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-rt-private-${count.index}"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.azs) # 2번 반복 (Private AZ-a, Private AZ-c)

  subnet_id      = aws_subnet.private[count.index].id
  # Private AZ-a 서브넷도 [0]번 지도를 받고, Private AZ-c 서브넷도 똑같은 [0]번 지도를 받는다.
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}