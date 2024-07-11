# resource "aws_subnet" "public" {
#   count = length(var.subnet_ids)
#   vpc_id = var.vpc_id

#   id = element(var.subnet_ids, count.index)

#   tags = {
#     Name = "public-subnet-${count.index}"
#   }
# }
