variable "location" {
    type = String
    default = "westeurope"
}

variable "project" {
    type = String
    default = "nimbux-moyano"
}

variable "tf-version" {
    type = number
    default = "2.19"
}

variable "env" {
    type = String
    default = "dev"

    validation {
        condition     = var.env == "dev" || var.env == "qa" || var.env == "prod"
        error_message = "Environment value error, allowed values ​​are: [\"dev\", \"qa\", \"prod\"]."
  }
}