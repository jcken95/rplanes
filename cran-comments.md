This is a re-upload of the initial CRAN submission for the package. We have responded to the suggestions from CRAN maintainers:

- We have removed "in R" from the package title.
- We no longer begin the description field with "this package".
- We do not have any references to add to the description field.
- We were previously using "\dontrun" in two examples, one of which demonstrated how to launch a web server with a wrapper function and the other took >45 seconds to execute. We have now switched to using "\donttest" for the long-running example.

## Test environments

- Local MacOS install, R 4.2.3
- R hub
    - Linux (Ubuntu 22.04.4 LTS, R-devel)
    - Windows (Windows Server 2022 x64, R-devel)
    - MacOS (macOS Ventura 13.6.7, R-devel)
    - MacOS ARM 64 (macOS Sonoma 14.5, R-devel)

## R CMD check results

- Local `R CMD check`
  - 0 errors | 0 warnings | 0 notes
- R hub: 
    - Linux (Ubuntu 22.04.4 LTS, R-devel)
      - 0 errors | 0 warnings | 0 notes
    - Windows (Windows Server 2022 x64, R-devel)
      - 0 errors | 0 warnings | 0 notes
    - MacOS (macOS Ventura 13.6.7, R-devel)
      - 0 errors | 0 warnings | 0 notes
    - MacOS ARM 64 (macOS Sonoma 14.5, R-devel)
      - 0 errors | 0 warnings | 0 notes


