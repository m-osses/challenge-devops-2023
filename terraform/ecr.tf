resource "aws_ecrpublic_repository" "challenge_ecr" {
  repository_name = "challenge-ecr"

  catalog_data {
    about_text        = "Images for challenge devops 2023"
    architectures     = ["ARM", "x86-64"]
    operating_systems = ["Linux"]
  }

  tags = {
    terraform = true
  }
}
