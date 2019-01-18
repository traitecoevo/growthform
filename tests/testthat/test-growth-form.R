context("growthform")


test_that("table sane", {
  library(growthform)
  lookup <- growthform::growth_form()
  expect_that(ncol(lookup), equals(4L))
  expect_that(lookup, is_a("data.frame"))
  expect_that(any(is.na(lookup$support)), is_false())
  expect_that(any(duplicated(lookup$sp)), is_false())
})
