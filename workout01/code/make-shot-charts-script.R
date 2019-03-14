###################################################################################################
#title: Make Shots Chart Script
#description: Using the data aggregated in make-shots-data-script to create scatterplots of player data.
#input(s): shots-data.csv
#output(s): plotting of shots in PDF and PNG formats
###################################################################################################

library(ggplot2)
library(grid)
library(jpeg)

data_types = c("team_name"="character", "game_date"="character", "season" = "integer", "period"="integer",
               "minutes_remaining"="integer", "seconds_remaining"="integer", "shot_made_flag"="character",
               "action_type"="factor", "shot_type"="factor", "shot_distance"="integer", "opponent"="character",
               "x"="integer", "y"="integer")

players <- read.csv('../data/shots-data.csv', stringsAsFactors = FALSE, colClasses=data_types)

#court image
court_file <- "../images/nba-court.jpg"

#creat raste object
court_image = rasterGrob(
  readJPEG(court_file),
  width = unit(1, "npc"),
  height = unit(1, "npc"))

#thompson
thompson <- players[players$name == "Klay Thompson",]

pdf("../images/klay-thompson-shot-chart.pdf", width = 6.5, height = 5)
ggplot(data = thompson)+
  annotation_custom(court_image, -250, 250, -50, 420)+
  geom_point(aes(x = x, y = y, color = shot_made_flag))+
  ylim(-50,420)+
  ggtitle("Shot Chart: Klay Thompson (2016 season)")+
  theme_minimal()
dev.off()

#iguodala
iguodala <- players[players$name == "Andre Iguodala",]

pdf("../images/andre-iguodala-shot-chart.pdf", width = 6.5, height = 5)
ggplot(data = iguodala)+
  annotation_custom(court_image, -250, 250, -50, 420)+
  geom_point(aes(x = x, y = y, color = shot_made_flag))+
  ylim(-50,420)+
  ggtitle("Shot Chart: Andre Iguodala (2016 season)")+
  theme_minimal()
dev.off()

#durant
durant <- players[players$name == "Kevin Durant",]

pdf("../images/kevin-durant-shot-chart.pdf", width = 6.5, height = 5)
ggplot(data = durant)+
  annotation_custom(court_image, -250, 250, -50, 420)+
  geom_point(aes(x = x, y = y, color = shot_made_flag))+
  ylim(-50,420)+
  ggtitle("Shot Chart: Kevin Durant (2016 season)")+
  theme_minimal()
dev.off()  

#curry
curry <- players[players$name == "Stephen Curry",]

pdf("../images/stephen-curry-shot-chart.pdf", width = 6.5, height = 5)
ggplot(data = curry)+
  annotation_custom(court_image, -250, 250, -50, 420)+
  geom_point(aes(x = x, y = y, color = shot_made_flag))+
  ylim(-50,420)+
  ggtitle("Shot Chart: Stephen Curry (2016 season)")+
  theme_minimal()
dev.off()  

#green
green <- players[players$name == "Draymond Green",]

pdf("../images/draymond-green-shot-chart.pdf", width = 6.5, height = 5)
ggplot(data = green)+
  annotation_custom(court_image, -250, 250, -50, 420)+
  geom_point(aes(x = x, y = y, color = shot_made_flag))+
  ylim(-50,420)+
  ggtitle("Shot Chart: Draymond Green (2016 season)")+
  theme_minimal()
dev.off()  

#facetted shot chart
facetted_shot_chart <- ggplot(data = players) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Charts: GSW (2016 season)') +
  theme_minimal()+
  facet_grid(~ name)

pdf('../images/gsw-shot-charts.pdf', width=8,height=7)
facetted_shot_chart
dev.off()

png('../images/gsw-shot-charts.png', width=8,height=7, units="in", res = 72)
facetted_shot_chart
dev.off()