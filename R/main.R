private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

if (file.exists(private_filename)) {
  source(private_filename)
} else {
  source(template_filename)
}

