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
string_line <- function() {

  raw_csv <- read.csv(check.names = FALSE,
                              system.file("extdata",
                                          # "london_edinburgh_test.csv",
                                          "glq_edb_via_fkk.csv",
                                          package = "stringliner"))

  # add distance along tracks or as the crow flies (not the car drive)

  distances <- raw_csv %>%
    names() %>%
    .[substring(., 1, 8) == "station|"] %>%
    substring(9) %>%
    strsplit("|", fixed = TRUE) %>%
    transpose() %>%
    map(unlist) %>%
    `names<-`(c("station", "dist_miles")) %>%
    data.frame() %>%
    `[[<-`("dist_miles",
           value = as.numeric(levels(.[["dist_miles"]]))[.[["dist_miles"]]])

  time_table <- raw_csv %>%
    `names<-`(c(names(raw_csv)[substring(names(raw_csv), 1, 8) != "station|"],
              as.character(distances[["station"]]))) %>%
    mutate(journey = 1:n()) %>%
    gather(key = "station", value = "time", -direction, -journey) %>%
    mutate(time = hm(time) + ymd_hms("2000-01-01 00:00:00")) %>%
    left_join(distances) %>%
    filter(!is.na(time))

  string_line <- ggplot(time_table, aes(time, dist_miles)) +
    geom_path(aes(group = journey)) +
    geom_point() +
    scale_y_continuous(breaks = time_table[["dist_miles"]],
                       labels = time_table[["station"]]) +
    scale_x_datetime(date_labels = "%H:%M") +
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank())

  return(string_line)
}

