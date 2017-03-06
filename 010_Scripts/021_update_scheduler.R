library(cronR)

weekly_update <- "/Users/SeanWarlick/Documents/GitHub/shiny-swimming/010_Scripts/20_weekly_data_updates.R"
weekly_log = "Users/SeanWarlick/GitHub/shiny-swimming/data_download/weekly_update.log"


script_cron <- cron_rscript(weekly_update,  
							log_append = FALSE)

cron_add(command = script_cron, frequency = 'daily', at = "18:21", id = "test")

