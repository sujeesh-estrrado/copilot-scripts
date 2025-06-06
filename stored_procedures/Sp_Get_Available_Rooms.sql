IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Available_Rooms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure  [dbo].[Sp_Get_Available_Rooms] -- ''''SAT'''',''''12/6/2015 2:00:00 AM'''',''''12/9/2015 3:00:00 AM'''',''''12/7/2015 12:00:00 AM'''',
--''''12/8/2015 12:00:00 AM'''',6
    @weekcode varchar(50),
@stratTime datetime,
@EndTime datetime,
@from_date datetime,
@to_date datetime,
@Campus_Id bigint
AS
BEGIN


--Declare @fDate  datetime
--Declare @Tdate  datetime
--
--Declare @fDate2  varchar(50)
--Declare @Tdate22 varchar(50)
--
--set @fDate2=''''12/7/2015 12:00:00 AM''''
--
--set @TDate22=''''12/8/2015 12:00:00 AM''''
--
-- set @fDate=convert(datetime, DATEADD(day,-1,convert(datetime,@fDate2)))
-- set @fDate=convert(datetime, DATEADD(day,-1,convert(datetime,@fDate2)))
--set @Tdate=DATEADD(day,1,convert(datetime,@TDate22))
-- set @fDate= DATEADD(day,-1,convert(datetime,@from_date))
--set @Tdate=DATEADD(day,1,convert(datetime,@to_date))


SELECT    Tbl_Room.Room_Name+'' - ''+Tbl_Floor.Floor_Name+'' - ''+Tbl_Block.Block_Name as Room_Name ,Tbl_Room.Room_Id     
       
FROM         Tbl_Room INNER JOIN      
                      Tbl_Floor ON Tbl_Room.Floor_Id = Tbl_Floor.Floor_Id INNER JOIN      
                      Tbl_Block ON Tbl_Room.Block_Id = Tbl_Block.Block_Id INNER JOIN      
                      Tbl_Campus ON Tbl_Room.Campus_Id = Tbl_Campus.Campus_Id      
   
where  Tbl_Campus.Campus_Id = @Campus_Id 

and   Tbl_Room.Room_Id not in(



SELECT   RSM.Room_Id
       
FROM          dbo.Tbl_Room_Subject_Mapping as RSM 
where  RSM.Campus_Id = @Campus_Id 
--
and  (convert(char(5), @stratTime, 108) between 
convert(char(5),RSM.Start_Time,108)
 and 
convert(char(5),RSM.End_Time,108)
--
and  convert(char(5), @EndTime, 108) between 
convert(char(5),RSM.Start_Time,108)
 and 
convert(char(5),RSM.End_Time,108))
or 
convert(char(5), @stratTime, 108)=RSM.Start_Time or 
convert(char(5), @EndTime, 108)=RSM.End_Time
 and 
@from_date between RSM.Mapping_FromDate and RSM.Mapping_ToDate
and 
@to_date between RSM.Mapping_FromDate and RSM.Mapping_ToDate
and RSM.WeekDay_Code=@weekcode)





END

    ')
END
