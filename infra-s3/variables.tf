variable "aws_region" {
  description = "Region for S3-bucket"
  type        = string
  default     = "eu-west-1"
}

variable "candidate_id" {
  description = "Kandidatnummer, brukes i bucket-navn"
  type        = string
}

variable "tmp_transition_days" {
  description = "Dager før midlertidige filer flyttes til Glacier"
  type        = number
  default     = 7
}

variable "tmp_expiration_days" {
  description = "Dager før midlertidige filer slettes"
  type        = number
  default     = 30
}
