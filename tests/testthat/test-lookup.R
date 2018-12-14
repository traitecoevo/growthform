context("growthform")

test_that("lookup sane", {
  library(growthform)
  checkingPinus<-growthform::growth_form_lookup_table("Pinus ponderosa")
  expect_that(checkingPinus$sp, equals("Pinus ponderosa"))
  expect_that(checkingPinus$support, equals("F"))
  expect_that(any(is.na(checkingPinus)), is_false())
  expect_that(any(checkingPinus == ""), is_false())
  expect_that(any(duplicated(checkingPinus$sp)), is_false())
})
