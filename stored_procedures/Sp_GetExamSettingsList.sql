IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetExamSettingsList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetExamSettingsList] --0,0,0,1                
(@periodid bigint=0,@intake bigint=0,@pgmid bigint=0,@pagesize bigint=0,@pageno bigint=0,            
@flag bigint=0)                
as                
begin              
if(@flag=1)            
begin            
if(@periodid=0)                
begin                
                
select IM.intake_no as intake,(select top 1 Exam_Name from Tbl_Exam_Schedule where Tbl_Exam_Schedule.Exam_Master_Id=EM.Exam_Master_id) as Name,         
D.Department_Name as pgm,CS.Semester_Name, Em.Exam_Master_id as id, 
case when (select top 1 CONVERT(VARCHAR(10), Last_Edit_date, 103) from [Tbl_Exam_settings] where Exam_Schedule = EM.Exam_Master_id) is null then ''-NA-'' else 
(select top 1 CONVERT(VARCHAR(10), Last_Edit_date, 103) from [Tbl_Exam_settings] where Exam_Schedule = EM.Exam_Master_id) end as last_date       
from Tbl_Exam_Master EM        
inner join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=Em.Duration_Period_id        
inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id         
inner join Tbl_Course_Semester CS on CS.Semester_Id=CPD.Semester_Id        
inner join Tbl_IntakeMaster IM on Im.id=CBD.IntakeMasterID        
inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id        
where Publish_status=2 and             
(CBD.IntakeMasterID=@intake or @intake=0) and (CBD.Duration_Id=@pgmId or @pgmid=0)               
and Em.delete_status=0                
order by EM.Exam_master_id desc            
OFFSET @pagesize * (@pageno - 1) ROWS             
FETCH NEXT @pagesize ROWS ONLY              
end                
                
else                
begin                
                 
select IM.intake_no as intake,(select top 1 Exam_Name from Tbl_Exam_Schedule where Tbl_Exam_Schedule.Exam_Master_Id=EM.Exam_Master_id) as Name,         
D.Department_Name as pgm,CS.Semester_Name, Em.Exam_Master_id as id,       
case when (select top 1 CONVERT(VARCHAR(10), Last_Edit_date, 103) from [Tbl_Exam_settings] where Exam_Schedule = EM.Exam_Master_id) is null      
then ''-NA-'' else (select top 1 CONVERT(VARCHAR(10), Last_Edit_date, 103) from [Tbl_Exam_settings] where Exam_Schedule = EM.Exam_Master_id) end as last_date       
from Tbl_Exam_Master EM        
      
inner join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=Em.Duration_Period_id        
inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id         
inner join Tbl_Course_Semester CS on CS.Semester_Id=CPD.Semester_Id        
inner join Tbl_IntakeMaster IM on Im.id=CBD.IntakeMasterID        
inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id        
where Publish_status=2 and                    
Em.Duration_Period_id=@periodid And Em.delete_status=0                
                
order by EM.Exam_master_id desc            
OFFSET @pagesize * (@pageno - 1) ROWS             
FETCH NEXT @pagesize ROWS ONLY              
end                
end            
            
if(@flag=2)            
begin            
if(@periodid=0)                
begin                
                
select COUNT(Em.Exam_master_id) AS COUNT                
                
from Tbl_Exam_Master EM        
inner join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=Em.Duration_Period_id        
inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id         
inner join Tbl_Course_Semester CS on CS.Semester_Id=CPD.Semester_Id        
inner join Tbl_IntakeMaster IM on Im.id=CBD.IntakeMasterID        
inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id        
where Publish_status=2 and (CBD.IntakeMasterID=@intake or @intake=0) and (CBD.Duration_Id=@pgmId or @pgmid=0)               
And Em.delete_status=0                
end                
                
else                
begin                
                 
select COUNT(Em.Exam_master_id) AS COUNT              
from Tbl_Exam_Master EM        
inner join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=Em.Duration_Period_id        
inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id         
inner join Tbl_Course_Semester CS on CS.Semester_Id=CPD.Semester_Id        
inner join Tbl_IntakeMaster IM on Im.id=CBD.IntakeMasterID        
inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id        
where Publish_status=2 and Em.Duration_Period_id=@periodid And Em.delete_status=0                
                
end                
end            
            
end 
');
END;