IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Event_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Event_Report] --''Campus Visit''  
   
@EventType varchar(Max) = ''''  
  
  
as    
begin    
Declare @JanDone bigint    
Declare @JanUpcoming bigint    
Declare @FebDone bigint    
Declare @FebUpcoming bigint  
Declare @MarDone bigint    
Declare @MarUpcoming bigint  
Declare @AprDone bigint  
Declare @AprUpcoming bigint  
Declare @MayDone bigint    
Declare @MayUpcoming bigint  
Declare @JunDone bigint    
Declare @JunUpcoming bigint  
Declare @JulDone bigint    
Declare @JulUpcoming bigint  
Declare @AugDone bigint    
Declare @AugUpcoming bigint  
Declare @SepDone bigint     
Declare @SepUpcoming bigint  
Declare @OctDone bigint    
Declare @OctUpcoming bigint  
Declare @NovDone bigint     
Declare @NovUpcoming bigint  
Declare @DecDone bigint     
Declare @DecUpcoming bigint  
declare @CurrentMonth Datetime  
set @CurrentMonth=(MONTH(GETDATE()))  
  
  
  
  
if(@CurrentMonth = 1)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                               
           
    
set @JanUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=1 and TypeOfEvent=@EventType)  
    
             
    
set @FebUpcoming=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempJan(valuetype varchar(Max),value bigint)    
insert into #tempJan    
select''JanDone'',@JanDone as JunDone  union all   
select''JanUpcoming'',@JanUpcoming as JunUpcoming  union all   
select''FebUpcoming'',@FebUpcoming as FebUpcoming    
    
select * from #tempJan   
  
end  
if(@CurrentMonth = 2)  
begin  
  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                               
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @FebUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
  
  
set @MarUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempFeb(valuetype varchar(Max),value bigint)    
insert into #tempFeb    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''FebUpcoming'',@FebUpcoming as FebUpcoming union all   
select''MarUpcoming'',@MarUpcoming as MarUpcoming   
    
select * from #tempFeb     
    
end  
if(@CurrentMonth = 3)  
begin  
  
  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=3 and TypeOfEvent=@EventType )  
  
set @MarUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=3 and TypeOfEvent=@EventType )  
  
set @AprUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempMar(valuetype varchar(Max),value bigint)    
insert into #tempMar    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''MarUpcoming'',@MarUpcoming as MarUpcoming union all   
select''AprUpcoming'',@AprUpcoming as AprUpcoming   
    
select * from #tempMar     
    
  
    
end  
if(@CurrentMonth = 4)  
begin  
  
  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType )                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
   
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
  
set @AprUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
  
set @MayUpcoming=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempApr(valuetype varchar(Max),value bigint)    
insert into #tempApr    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''AprUpcoming'',@AprUpcoming as AprUpcoming union all   
select''MayUpcoming'',@MayUpcoming as MayUpcoming union all   
    
select * from #tempApr      
    
end  
if(@CurrentMonth = 5)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @MayUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
set @JunUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempMay(valuetype varchar(Max),value bigint)    
insert into #tempMay    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''MayUpcoming'',@MayUpcoming as AprUpcoming union all   
select''JunUpcoming'',@JunUpcoming as JunUpcoming   
    
select * from #tempMay    
    
end  
if(@CurrentMonth = 6)  
begin  
  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
 set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
  
set @JunUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempJun(valuetype varchar(Max),value bigint)    
insert into #tempJun    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JunUpcoming'',@JunUpcoming as JunUpcoming union all   
select''JulUpcoming'',@JulUpcoming as JulUpcoming   
    
select * from #tempJun     
    
end  
if(@CurrentMonth = 7)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @JulUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempJul(valuetype varchar(Max),value bigint)    
insert into #tempJul    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''JunUpcoming'',@JunUpcoming as JunUpcoming union all   
select''AugUpcoming'',@JulUpcoming as JulUpcoming   
    
select * from #tempJul     
    
end  
if(@CurrentMonth = 8)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @AugUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @SepUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
    
  
     
  Create table #tempAug(valuetype varchar(Max),value bigint)    
insert into #tempAug    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''AugDone'',@AugDone as AugDone union all   
select''AugUpcoming'',@AugUpcoming as AugUpcoming union all   
select''SepUpcoming'',@SepUpcoming as SepUpcoming   
  
select * from #tempAug  
  
end  
if(@CurrentMonth = 9)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @SepDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
  
set @SepUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
    
set @OctUpcoming=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=10 and TypeOfEvent=@EventType)  
     
  Create table #tempSep(valuetype varchar(Max),value bigint)    
insert into #tempSep    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''AugDone'',@AugDone as AugDone union all   
select''SepDone'',@SepDone as SepDone union all   
select''SepUpcoming'',@SepUpcoming as SepUpcoming union all   
select''OctUpcoming'',@OctUpcoming as OctUpcoming   
  
select * from #tempSep   
    
end  
if(@CurrentMonth = 10)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @SepDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
  
set @OctDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and MONTH(Start_Date)=10 and TypeOfEvent=@EventType)  
    
set @OctUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and  MONTH(Start_Date)=10 and TypeOfEvent=@EventType)  
  
set @NovUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=11 and TypeOfEvent=@EventType)  
     
     
  Create table #tempOct(valuetype varchar(Max),value bigint)    
insert into #tempOct    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''AugDone'',@AugDone as AugDone union all   
select''SepDone'',@SepDone as SepDone union all   
select''OctDone'',@OctDone as OctDone union all   
select''OctUpcoming'',@OctUpcoming as OctUpcoming union all   
select''NovUpcoming'',@NovUpcoming as NovUpcoming   
  
select * from #tempOct    
    
end  
if(@CurrentMonth = 11)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @SepDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
  
set @OctDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=10 and TypeOfEvent=@EventType)  
    
set @NovDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and  MONTH(Start_Date)=11 and TypeOfEvent=@EventType)  
  
set @NovUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date>GETDATE() and MONTH(Start_Date)=11 and TypeOfEvent=@EventType)  
set @DecUpcoming=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=12 and TypeOfEvent=@EventType)  
     
     
  Create table #tempNov(valuetype varchar(Max),value bigint)    
insert into #tempNov    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''AugDone'',@AugDone as AugDone union all   
select''SepDone'',@SepDone as SepDone union all   
select''OctDone'',@OctDone as OctDone union all   
select''NovDone'',@NovDone as NovDone union all   
select''NovUpcoming'',@NovUpcoming as NovUpcoming union all   
select''DecUpcoming'',@DecUpcoming as DecUpcoming   
  
select * from #tempNov   
    
end  
if(@CurrentMonth = 12)  
begin  
  
set @JanDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=1 and TypeOfEvent=@EventType)                                
           
    
  
 set @FebDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=2 and TypeOfEvent=@EventType)  
             
    
set @MarDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=3 and TypeOfEvent=@EventType)  
  
  
set @AprDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=4 and TypeOfEvent=@EventType)  
set @MayDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=5 and TypeOfEvent=@EventType)  
  
set @JunDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=6 and TypeOfEvent=@EventType)  
set @JulDone=(select COUNT(*) from Tbl_Event_Details where MONTH(Start_Date)=7 and TypeOfEvent=@EventType)  
  
set @AugDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=8 and TypeOfEvent=@EventType)  
  
set @SepDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=9 and TypeOfEvent=@EventType)  
  
set @OctDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=10 and TypeOfEvent=@EventType)  
    
set @NovDone=(select COUNT(*) from Tbl_Event_Details where  MONTH(Start_Date)=11 and TypeOfEvent=@EventType)  
  
set @DecDone=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and  MONTH(Start_Date)=12 and TypeOfEvent=@EventType)  
set @DecUpcoming=(select COUNT(*) from Tbl_Event_Details where Start_Date<GETDATE() and  MONTH(Start_Date)=12 and TypeOfEvent=@EventType)  
     
     
  Create table #tempDec(valuetype varchar(Max),value bigint)    
insert into #tempDec    
select''JanDone'',@JanDone as JunDone  union all   
select''FebDone'',@FebDone as FebDone  union all   
select''MarDone'',@MarDone as MarDone union all   
select''AprDone'',@AprDone as AprDone union all   
select''MayDone'',@MayDone as MayDone union all   
select''JunDone'',@JunDone as JunDone union all   
select''JulDone'',@JulDone as JulDone union all   
select''AugDone'',@AugDone as AugDone union all   
select''SepDone'',@SepDone as SepDone union all   
select''OctDone'',@OctDone as OctDone union all   
select''NovDone'',@NovDone as NovDone union all   
select''DecDone'',@DecDone as DecDone union all   
select''DecUpcoming'',@DecUpcoming as DecUpcoming   
  
select * from #tempDec   
    
end  
  
     
    
end  
    ')
END
