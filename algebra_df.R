library(stringr)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

#create a summary of the types of questions that have been asked on 
#each common core algebra regents

###used to create text file from online pdf
###library(tm)
###algebra <- download.file("http://www.jmap.org/JMAPArchives/JMAP6784/JMAPAI_REGENTS_BOOK_BY_CCSS_TOPIC.pdf",
###                         "algebra.pdf")
###alg_doc <- readPDF(control = list(text = "-layout"))(elem = list(uri = "algebra.pdf"),
###                                                     language = "en",
###                                                     id = "id1")
###write(unlist(alg_doc[1]), "algebra_text.txt")

alg <- readLines("algebra_text.txt")
alg <- paste(alg, collapse = " ")

question_index <- as.integer(str_match_all(alg, "(\\d+)\\sANS")[[1]][,2])
test_meta_data <- str_match_all(alg, 
                                "REF:\\s(\\d{2}|\\D{3,4})(\\d{2})(\\d{2})(\\w{2})")
test_type <- test_meta_data[[1]][,5]
test_month <- test_meta_data[[1]][,2]
test_year <- as.integer(test_meta_data[[1]][,3])
test_question <- as.integer(test_meta_data[[1]][,4])
answer <- str_match_all(alg, "ANS:\\s(.).")[[1]][,2]
answer <- str_replace_all(answer, "[^1-4]", "NA")
points <- as.integer(str_match_all(alg, "PTS:\\s(\\d).")[[1]][,2])
ccss <- str_match_all(alg, "NAT:\\s(.+?)\\s")[[1]][,2]
ccss <- str_trim(ccss)
algebra_df <- data_frame(i=question_index, test=test_type, month=test_month, 
                         year=test_year, question=test_question, answer=answer,
                         points=points, ccss=ccss)

algebra_df$month[algebra_df$month=='01'] <- "January"
algebra_df$month[algebra_df$month=='06'] <- "June"
algebra_df$month[algebra_df$month=='08'] <- "August"

algebra_df <- algebra_df %>% separate(ccss, 
                                      into=c("concept", "domain", "cluster"), 
                                      sep="\\.") %>%
                             mutate(test_name=str_c(month, "_", "20", year)) %>%
                             filter(month != "fall") %>%
                             filter(month != "spr") 
algebra_df$is.mc <- algebra_df$question < 25

algebra_df$concept[algebra_df$concept=='A'] <- "Algebra"
algebra_df$concept[algebra_df$concept=='F'] <- "Functions"
algebra_df$concept[algebra_df$concept=='N'] <- "Number & Quantity"
algebra_df$concept[algebra_df$concept=='S'] <- "Statistics and Probability"

