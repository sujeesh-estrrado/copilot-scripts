IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DatewiseExam_Schedule_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_DatewiseExam_Schedule_Report] --''1/12/2016 12:00:00 AM'',''3/12/2016 12:00:00 AM'',2      
      
(@fromdate datetime,@todate datetime,@status bigint)      
      
as begin      
      
if(@status=0)      
begin      
select ExamCode,ExamDescription,convert(varchar(15),ExamDate,103) AS ExamDate,Invigilator,Venue,ExamTerm,      
case OpenStatus      
when ''0'' then ''Closed''      
else ''Open''      
end as OpenStatus      
from dbo.Tbl_GroupChangeExamDates where  ExamDate between      
@fromdate and @todate and ExamCode is not null     
end      
      
else if(@status=1)      
begin      
select ExamCode,ExamDescription,convert(varchar(15),ExamDate,103) AS ExamDate,Invigilator,Venue,ExamTerm,      
case OpenStatus      
when ''0'' then ''Closed''      
else ''Open''      
end as OpenStatus      
from dbo.Tbl_GroupChangeExamDates where  ExamDate between      
@fromdate and @todate and OpenStatus=1 and ExamCode is not null      
end      
       
else if (@status=2)      
begin      
select ExamCode,ExamDescription,convert(varchar(15),ExamDate,103) AS ExamDate,Invigilator,Venue,ExamTerm,      
case OpenStatus      
when ''0'' then ''Closed''      
else ''Open''      
end as OpenStatus      
from dbo.Tbl_GroupChangeExamDates where    ExamDate between      
@fromdate and @todate and OpenStatus=0 and ExamCode is not null    
end      
      
end   
    ')
END
