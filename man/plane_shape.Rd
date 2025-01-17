% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/planes.R
\name{plane_shape}
\alias{plane_shape}
\title{Shape component}
\usage{
plane_shape(location, input, seed, method = "sdiff")
}
\arguments{
\item{location}{Character vector with location code; the location must appear in input and seed}

\item{input}{Input signal data to be scored; object must be one of \link[=to_signal]{forecast}}

\item{seed}{Prepared \link[=plane_seed]{seed}}

\item{method}{The method for determining shapes; must be one of "sdiff" or "dtw" (see Details); default is "sdiff"}
}
\value{
A \code{list} with the following values:
\itemize{
\item \strong{indicator}: Logical as to whether or not the the shape of the evaluated signal is novel (\code{TRUE} if shape is novel, \code{FALSE} if a familiar shape exists in the seed)
}
}
\description{
This function identifies the shape of the trajectory for a forecasted signal to compare against existing shapes in seed data. If the shape is identified as novel, a flag is raised, and the signal is considered implausible. See the Details section for further information.
}
\details{
The approach for determining shapes can be customized by the user with the \code{plane_shape()} "method" argument. The two methods available are "sdiff" (default) and "dtw". Compared with "sdiff", the "dtw" method has been shown to have a higher sensitivity, lower specificity, and much greater computational cost in some circumstances. The "sdiff" method is recommended if computational efficiency is a concern.

The "sdiff" method will use consecutive scaled differences to construct shapes. The algorithm operates in three steps:
\enumerate{
\item The prepared \link[=plane_seed]{seed} data is combined with forecasted point estimates and each point-to-point difference is calculated.
\item The differences are centered and scaled, then cut into categories. Differences greater than or equal to one standard deviation above the mean of differences are considered an "increase". Differences less than or equal to one standard deviation below  the mean of differences are considered a "decrease". All other differences are considered "stable".
\item The categorical differences are then combined into windows of equal size to the forecasted horizon. Collectively these combined categorical differences create a "shape" (e.g., "increase;stable;stable;decrease").
\item Lastly, the algorithm compares the shape for the forecast to all of the shapes observed. If the shape assessed has not been previously observed in the time series then a flag is raised and the indicator returned is \code{TRUE}.
}

The "dtw" method uses a Dynamic Time Warping (DTW) algorithm to identify shapes within the seed data and then compares the shape of the forecast input signal to the observed shapes. This is done in three broad steps:
\enumerate{
\item The prepared \link[=plane_seed]{seed} data is divided into a set of sliding windows with a step size of one, each representing a section of the overall time series. The length of these windows is determined by the horizon length of the input data signal (e.g., 2 weeks). For example, if the seed data was a vector, \code{c(1, 2, 3, 4, 5)}, and the horizon length was 2, then the sliding windows for the observed seed data would be: \code{c(1, 2)}, \code{c(2, 3)}, \code{c(3, 4)}, and \code{c(4, 5)}. Each sliding window is a subset of the total trajectory shape of the observed data.
\item Shape-based DTW distances are calculated for every 1x1 combination of the observed sliding windows and are stored in a distance matrix. These distances calibrate the function for identifying outlying shapes in forecast data. The algorithm finds the minimum distances for each windowed time series to use as a baseline for "observed distances" between chunks of the larger observed time series. The maximum of those minimum distances across the observed time series is set as the threshold. If the minimum of the forecast:observed distance matrix is greater than the threshold, then the forecast is inferred to be unfamiliar (i.e., a novel shape).
\item Next, the algorithm calculates the shape-based DTW distances between the forecast signal (including the point estimate, lower, and upper bounds) and every observed sliding window. If the distance between the forecast and any observed sliding window is less than or equal to the threshold defined above, then this shape is not novel and no flag is raised (indicator is \code{FALSE}).
}
}
\examples{
## read in example observed data and prep observed signal
hosp <- read.csv(system.file("extdata/observed/hdgov_hosp_weekly.csv", package = "rplanes"))

tmp_hosp <-
 hosp \%>\%
 dplyr::select(date, location, flu.admits) \%>\%
 dplyr::mutate(date = as.Date(date))

prepped_observed <- to_signal(tmp_hosp,
                               outcome = "flu.admits",
                               type = "observed",
                               resolution = "weeks")
## read in example forecast and prep forecast signal
prepped_forecast <- read_forecast(system.file("extdata/forecast/2022-10-31-SigSci-TSENS.csv",
                                                package = "rplanes")) \%>\%
   to_signal(., outcome = "flu.admits", type = "forecast", horizon = 4)

## prepare seed with cut date
prepped_seed <- plane_seed(prepped_observed, cut_date = "2022-10-29")

## run plane component
plane_shape(location = "37", input = prepped_forecast, seed = prepped_seed)

## run plane component with DTW method
plane_shape(location = "37", input = prepped_forecast, seed = prepped_seed, method = "dtw")

}
\references{
Toni Giorgino. Computing and Visualizing Dynamic Time Warping Alignments in R: The dtw Package. Journal of Statistical Software, 31(7), 1-24. doi:10.18637/jss.v031.i07

Tormene, P.; Giorgino, T.; Quaglini, S. & Stefanelli, M. Matching incomplete time series with dynamic time warping: an algorithm and an application to post-stroke rehabilitation. Artif Intell Med, 2009, 45, 11-34. doi:10.1016/j.artmed.2008.11.007
}
