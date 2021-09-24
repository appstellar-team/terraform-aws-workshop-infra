variable "name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "sse_enabled" {
  type        = bool
  description = "Do you want to enable server side encryption?"
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Server side encryption algorithm"
  default     = "AES256"
}

variable "force_destroy" {
  type        = bool
  description = "Indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. "
  default     = false
}

variable "acl" {
  type        = string
  description = "Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private"
  default     = "private"

  validation {
    condition     = contains(["private", "public-read", "public-read-write", "aws-exec-read", "authenticated-read", "log-delivery-write"], var.acl)
    error_message = "Allowed values for acl are \"private\", \"public-read-write\", \"aws-exec-read\", \"authenticated-read\", or \"log-delivery-write\"."
  }
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  default     = false
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  default     = false
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = false
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
