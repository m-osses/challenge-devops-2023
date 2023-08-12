resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state-bucket-challenge2023"

  tags = {
    Name        = "Terraform State Bucket"
  }
}
