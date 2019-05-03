library(testthat)

context("check binomial arguments")

test_that("check_prob with ok arguments", {
  expect_true(check_prob(1))
  expect_true(check_prob(0))
  expect_true(check_prob(0.5))
})

test_that("check_prob with bad arguments",{
  expect_error(check_prob(-0.5))
  expect_error(check_prob(2))
  expect_error(check_prob("character"))
  expect_error(check_prob(c(0.2, 0.5)))
})

test_that("check_trials with ok arguments", {
  expect_true(check_trials(0))
  expect_true(check_trials(5))
  expect_true(check_trials(10))
})

test_that("check_trials with bad arguments", {
  expect_error(check_trials(-5))
  expect_error(check_trials(5.5))
  expect_error(check_trials("character"))
})

test_that("check_success with ok arguments", {
  expect_true(check_success(3, 5))
  expect_true(check_success(c(1,2,3), 5))
  expect_true(check_success(0, 1))
  expect_true(check_success(1, 2))
})

test_that("check_success with bad arguments", {
  expect_error(check_success(-1 , 5))
  expect_error(check_success(1, c(2, 3)))
  expect_error(check_success(2, 1))
})

context("summary measures")

test_that("test aux_mean", {
  expect_equal(aux_mean(5,0.5), 2.5)
  expect_length(aux_mean(5, 0.5), 1)
  expect_is(aux_mean(5, 0.5),"numeric")
})

test_that("test aux_variance", {
  expect_equal(aux_variance(5,0.5), 1.25)
  expect_length(aux_variance(5, 0.5), 1)
  expect_is(aux_variance(5, 0.5),"numeric")
})

test_that("test aux_mode", {
  expect_equal(aux_mode(5, 0.5), 3)
  expect_length(aux_mode(5, 0.5), 1)
  expect_is(aux_mode(5, 0.5),"integer")
})

test_that("test aux_skewness", {
  expect_equal(round(aux_skewness(5,0.3),2),  0.39)
  expect_length(aux_skewness(5, 0.3), 1)
  expect_is(aux_skewness(5, 0.3),"numeric")
})

test_that("test aux_kurtosis", {
  expect_equal(round(aux_kurtosis(5,0.3),2),  -0.25)
  expect_length(aux_kurtosis(5, 0.3), 1)
  expect_is(aux_kurtosis(5, 0.3),"numeric")
})



context("binomial")

test_that("test bin_choose", {
  expect_equal(bin_choose(5,3), 10)
  expect_length(bin_choose(5, 3), 1)
  expect_error(bin_choose(3, 5),"k cannot be greater than n")
})

test_that("test bin_probability", {
  expect_equal(bin_probability(2,5,0.5), 0.3125)
  expect_length(bin_probability(2,5,0.5), 1)
  expect_error(bin_probability(6,5,0.5),"success cannot be greater than trials")
})

test_that("test bin_distribution", {
  expect_is(bin_distribution(5,0.5), "bindis")
  expect_length(bin_distribution(5,0.5), 2)
  expect_error(bin_distribution(5,1.1),"p has to be a number betwen 0 and 1")
})

test_that("test bin_cumulative", {
  expect_is(bin_cumulative(5,0.5), "bincum")
  expect_length(bin_cumulative(5,0.5), 3)
  expect_error(bin_cumulative(5,1.1),"p has to be a number betwen 0 and 1")
})

