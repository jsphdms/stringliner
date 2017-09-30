#' Sum of vector elements.
#'
#' \code{sum} returns the sum of all the values present in its arguments.
#'
#' This is a generic function: methods can be defined for it directly
#' or via the \code{\link{Summary}} group generic. For this to work properly,
#' the arguments \code{...} should be unnamed, and dispatch is on the
#' first argument.
#'
#' @param ... Numeric, complex, or logical vectors.
#' @param na.rm A logical scalar. Should missing values (including NaN)
#'   be removed?
#' @return If all inputs are integer and logical, then the output
#'   will be an integer. If integer overflow
#'   \url{http://en.wikipedia.org/wiki/Integer_overflow} occurs, the output
#'   will be NA with a warning. Otherwise it will be a length-one numeric or
#'   complex vector.
#'
#'   Zero-length vectors have sum 0 by definition. See
#'   \url{http://en.wikipedia.org/wiki/Empty_sum} for more details.
#' @examples
#' sum(1:10)
#' sum(1:5, 6:10)
#' sum(F, F, F, T, T)
#'
#' sum(.Machine$integer.max, 1L)
#' sum(.Machine$integer.max, 1)
#'
#' \dontrun{
#' sum("a")
#' }
stringline <- function() {

  timetable <- data.frame(station = c("London", "Birmingham", "Edinburgh"),
                          dist_miles = c(0, 126, 292),
                          time = c(hm("08:38"), hm("09:35"), hm("15:24")) +
                            + ymd_hms("2000-01-01 00:00:00"))

  ggplot(timetable, aes(time, dist_miles)) +
    geom_path() +
    scale_y_continuous(breaks = timetable[["dist_miles"]],
                       labels = timetable[["station"]]) +
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank())
}

