library(REdaS)

##################################### IMPORTING DATA #########################################
df = read.csv("", sep=",", stringsAsFactors = FALSE) #import csv. file with columns ID, azimuth, distance, ref_point
ref.df = read.csv("", sep=",", stringsAsFactors = FALSE) # import reference points (metric coordinate system) with columns ref_id, ref_x, ref_y
                                      #OR
df<- read.table("....txt", sep="\t", dec=",", header=TRUE) #import txt. file (example where the comma is specified as a decimal seperator)
ref.df<-read.table("....txt", sep="\t", dec=",", header=TRUE)
##################################### TRANSFORM AZIMUTH TO ALPHA ############################
df$alfa = ifelse(df$azimuth >0 & df$azimuth <90, 90-df$azimuth,      
          ifelse (df$azimuth >90 & df$azimuth<180,df$azimuth-90,   
          ifelse (df$azimuth >180 & df$azimuth<270, 270-df$azimuth, 
          ifelse(df$azimuth >270 & df$azimuth<360,df$azimuth-270,df$azimuth ))))

#############################################################################################
df$alfaRad = deg2rad(df$alfa)        #degrees to radians
df$a = sin(df$alfaRad)*df$distance   #calculate cathete 1, i.e. move in a north-south direction
df$b = sqrt(df$distance^2-df$a^2)    #calculate cathete 2, i.e. move in an east-west direction

df$ref_x=ref.df$ref_x[match(df$ref_point, ref.df$ref_id)]
df$ref_y=ref.df$ref_y[match(df$ref_point, ref.df$ref_id)]

##################################### CALCULATING TREE COORDINATES ##########################
while (any(is.na(df)==TRUE)) {                                              # if there are still empty values in df calculate until all trees have coordinates
  df$ref_x=ref.df$ref_x[match(df$ref_point, ref.df$ref_id)]
  df$ref_y=ref.df$ref_y[match(df$ref_point, ref.df$ref_id)]
  df$x = ifelse(df$azimuth >0 & df$azimuth <90, df$ref_x+df$b,              #calculate x coordinate
          ifelse(df$azimuth >90 & df$azimuth<180, df$ref_x+df$b,
          ifelse (df$azimuth >180 & df$azimuth<270, df$ref_x-df$b,
          ifelse(df$azimuth >270 & df$azimuth<360, df$ref_x-df$b,
          ifelse (df$azimuth ==0|df$azimuth ==180|df$azimuth ==360, df$ref_x,
          ifelse (df$azimuth ==90, df$ref_x+df$distance, df$ref_x-df$distance))))))
  
  df$y = ifelse(df$azimuth >0 & df$azimuth <90, df$ref_y+df$a,             #calculate y coordinate
          ifelse(df$azimuth >90 & df$azimuth<180, df$ref_y-df$a,
          ifelse (df$azimuth >180 & df$azimuth<270, df$ref_y-df$a,
          ifelse(df$azimuth >270 & df$azimuth<360, df$ref_y+df$a,
          ifelse (df$azimuth ==0|df$azimuth==360, df$ref_y+distance,
          ifelse (df$azimuth ==90|df$azimuth==270, df$ref_y, df$ref_y-df$distance))))))
  
  
  trees_coords = data.frame(df$ID, df$x, df$y)
  names(trees_coords) = c("ref_id", "ref_x", "ref_y")
  ref.df = rbind(ref.df,trees_coords)    # add trees to the reference dataframe
  ref.df = unique(ref.df[!is.na(ref.df$ref_x),])   #remove empty cells and duplicate values
}