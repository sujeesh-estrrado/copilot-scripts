IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetExamList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetExamList] --0,0,0,1                          
(@periodid bigint=0,@intake bigint=0,@pgmid bigint=0,@examstatus bigint=0,@pagesize bigint=0,@pageno bigint=0, @FacultyId bigint=0,                     
@flag bigint=0)                          
as                          
begin                        
if(@flag=1)                      
begin                      
if(@periodid=0  )                          
begin                          
                          
select concat(D.department_name,''-'',D.Course_Code) as Program,CBD.Batch_Code as Intake,CBD.Batch_Id,S.Semester_Id,D.Department_Id,Em.Publish_status,                          
L.Course_Level_Name as faculty ,S.Semester_Name as semester, CONVERT(VARCHAR(10),EM.Exam_start_date, 103)as Exam_start_date, CONVERT(VARCHAR(10),EM.Exam_end_date, 103)as Exam_end_date,                          
Case when Em.Publish_status=2 then ''Published''                            
                          
when Em.Publish_status=1 then ''Pending'' end as Status  ,Em.Exam_master_id, CONVERT(VARCHAR(10),EM.create_date, 103)as create_date,                          
EM.Exam_Name as Examname                          
                          
from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                            
 where(  CBD.IntakeMasterID=@intake or @intake=0) and  (CBD.Duration_Id=@pgmId or @pgmid=0) and(@FacultyId=0 or L.Course_Level_Id=@FacultyId)                        
 and (EM.Publish_status=@examstatus or @examstatus=0) And Em.delete_status=0   
 and (EM.Exam_end_date IS NOT null OR EM.Exam_start_date IS NOT null)                       
  order by EM.Exam_master_id desc            OFFSET @pagesize * (@pageno - 1) ROWS             FETCH NEXT @pagesize ROWS ONLY                        
 end                          
                          
                          
 else                          
 begin                          
                           
select concat(D.department_name,''-'',D.Course_Code) as Program,CBD.Batch_Code as Intake, CBD.Batch_Id,S.Semester_Id,D.Department_Id,Em.Publish_status,                         
L.Course_Level_Name as faculty ,S.Semester_Name as semester, CONVERT(VARCHAR(10),EM.Exam_start_date, 103)as Exam_start_date, CONVERT(VARCHAR(10),EM.Exam_end_date, 103)as Exam_end_date,                          
Case when Em.Publish_status=2 then ''Published''                            
                          
when Em.Publish_status=1 then ''Pending'' end as Status  ,Em.Exam_master_id, CONVERT(VARCHAR(10),EM.create_date, 103)as create_date,                          
EM.Exam_Name as Examname                          
                          
from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                            
 where  Em.Duration_Period_id=@periodid and (EM.Publish_status=@examstatus or @examstatus=0) And Em.delete_status=0                          
                          
      order by EM.Exam_master_id desc                        
   OFFSET @pagesize * (@pageno - 1) ROWS             FETCH NEXT @pagesize ROWS ONLY                        
 end                            end                      
                      
 if(@flag=2)                      
begin                      
if(@periodid=0  )                          
begin                          
                          
select COUNT( Em.Exam_master_id) AS COUNT                          
                          
from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                      
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                            
 where(  CBD.IntakeMasterID=@intake or @intake=0) and  (CBD.Duration_Id=@pgmId or @pgmid=0)  and(@FacultyId=0 or L.Course_Level_Id=@FacultyId)                       
 and (EM.Publish_status=@examstatus or @examstatus=0) And Em.delete_status=0                          
 end                          
                          
                          
 else                          
 begin                          
                           
select  COUNT( Em.Exam_master_id) AS COUNT                        
from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                            
 where  Em.Duration_Period_id=@periodid and (EM.Publish_status=@examstatus or @examstatus=0) And Em.delete_status=0                          
                          
                          
 end                          
    end                      
       if(@flag=3)              
                  
begin                
if(@periodid=0  )                          
begin                          
select concat(D.department_name,''-'',D.Course_Code) as Program,CBD.Batch_Code as Intake,CBD.Batch_Id,S.Semester_Id,D.Department_Id,Em.Publish_status,                          
L.Course_Level_Name as faculty ,S.Semester_Name as semester, CONVERT(VARCHAR(10),EM.Exam_start_date, 103)as Exam_start_date, CONVERT(VARCHAR(10),EM.Exam_end_date, 103)as Exam_end_date,                          
Case when Em.Publish_status=2 then ''Published''                            
                          
when Em.Publish_status=1 then ''Pending'' end as Status  ,Em.Exam_master_id, CONVERT(VARCHAR(10),EM.create_date, 103)as create_date,                          
EM.Exam_Name as Examname                          
                          
from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                
 where              
 (  CBD.IntakeMasterID=@intake or @intake=0) and  (CBD.Duration_Id=@pgmId or @pgmid=0)   and               
 Em.Publish_status=2 and Em.Exam_Master_id in (select Exam_Id from Tbl_MarkEntryMaster where Exam_Id=Em.Exam_Master_id)              
    order by EM.Exam_master_id desc                        
   OFFSET @pagesize * (@pageno - 1) ROWS             FETCH NEXT @pagesize ROWS ONLY                  
              
end              
else              
begin              
select concat(D.department_name,''-'',D.Course_Code) as Program,CBD.Batch_Code as Intake,CBD.Batch_Id,S.Semester_Id,D.Department_Id,Em.Publish_status,                          
L.Course_Level_Name as faculty ,S.Semester_Name as semester, CONVERT(VARCHAR(10),EM.Exam_start_date, 103)as Exam_start_date, CONVERT(VARCHAR(10),EM.Exam_end_date, 103)as Exam_end_date,                          
Case when Em.Publish_status=2 then ''Published''                            
                          
when Em.Publish_status=1 then ''Pending'' end as Status  ,Em.Exam_master_id, CONVERT(VARCHAR(10),EM.create_date, 103)as create_date,                          
EM.Exam_Name as Examname                          
                          
from Tbl_Exam_Master EM               
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                
 where              
 Em.Duration_Period_id=@periodid   and               
 Em.Publish_status=2 and Em.Exam_Master_id in (select Exam_Id from Tbl_MarkEntryMaster where Exam_Id=Em.Exam_Master_id)              
    order by EM.Exam_master_id desc                        
   OFFSET @pagesize * (@pageno - 1) ROWS             FETCH NEXT @pagesize ROWS ONLY                 
              
end              
end              
              
if(@flag=4)              
begin              
                      
if(@periodid=0  )                          
begin                          
select  COUNT( Em.Exam_master_id) AS COUNT from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                
 where              
 (  CBD.IntakeMasterID=@intake or @intake=0) and  (CBD.Duration_Id=@pgmId or @pgmid=0)   and               
 Em.Publish_status=2 and Em.Exam_Master_id in (select Exam_Id from Tbl_MarkEntryMaster where Exam_Id=Em.Exam_Master_id)              
              
              
end              
else              
begin              
select  COUNT( Em.Exam_master_id) AS COUNT from Tbl_Exam_Master EM                          
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                          
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                            
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                            
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                          
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                
 where              
 Em.Duration_Period_id=@periodid   and               
 Em.Publish_status=2 and Em.Exam_Master_id in (select Exam_Id from Tbl_MarkEntryMaster where Exam_Id=Em.Exam_Master_id)              
              
                 
                      
                     
end              
 end               
 end
 ');
END;