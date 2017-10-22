#' Plot a recreation of E.J. Marey's graphical train schedule (aka a stringline
#' chart).
#'
#' Stations are plotted vertically according to their relative distance. This
#' means the slope of each line corresponds to the speed of the train.
#'
#' This plot requires two data tables: a timetable and the distances between
#' stations. This can potentially lead to redundancy (repetition of stations) so
#' the demonstration datasets store these two tables in a special format as csv
#' files. The timetable is organised with a row for each journey and a column
#' for each station. Relative distances are stored in the headers. This function
#' parses this dataset and then plots a stringline chart.
#'
#' @param route String. The name of a csv file (without extension) in the
#'   extdata directory
#' @return A plot object. A stringline chart.
#' @examples
#' string_line()
#' string_line("london_edinburgh_test")

string_line <- function(route = "glq_edb_via_fkk") {

  raw_csv <- read.csv(check.names = FALSE,
                              system.file("extdata",
                                          paste0(route, ".csv"),
                                          package = "stringliner"))

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
