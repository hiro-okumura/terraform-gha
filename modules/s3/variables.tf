variable "common_tags" {
  description = "Project and environment tags"
  type = object({
    project     = string
    environment = string
  })
}
