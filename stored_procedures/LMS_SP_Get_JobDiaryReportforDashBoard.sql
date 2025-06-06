IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_JobDiaryReportforDashBoard]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_JobDiaryReportforDashBoard] --299               
--@Date datetime,                    
@User_Id bigint                                 
AS                                    
BEGIN                        
                    
 select ''Routine Job'' as TaskType ,JB.Date,RA.RoutineActivity_Id as Id,RA.JobDiary_Id,RA.RoutineTask as Task,RA.R_Estimated_Time as Estimated_Time,RA.R_Actual_Time as Actual_Time,'''' as Estimated_Date,                    
JB.User_Id,'''' as Wrk_Status from LMS_Tbl_RoutineActivity RA                    
inner join LMS_Tbl_JobDiary JB on RA.JobDiary_Id=JB.JobDairy_Id                    
where JB.Status=0 and RA.Status=0 and JB.User_Id=299 and JB.Date=''2017/03/24''              
                    
union                    
                    
select ''Assigned Job'' as TaskType,LAS.Assigned_Date as Date,LAS.AssignTask_Id as Id,0 as JobDiary_Id,LAS.Task_Name as Task,LAS.Estimated_Time,LAS.Actual_Time,convert(varchar,LAS.Target_Date,103) as Estimated_Date,                   
LAS.User_Id,case LAS.Status when 0 then ''Not Completed'' else ''Completed'' end as Wrk_Status from LMS_Tbl_AssignTaskToStudents  LAS                  
 where  LAS.Student_Id=299 and LAS.Target_Date=''2017/03/24''              
                
union                
                
                
select ''Daily Job'' as TaskType,JB.Date,DA.DailyActivity_Id as Id,DA.JobDiary_Id,DA.DailyTask as Task,DA.D_Estimated_Time as Estimated_Time,DA.D_Actual_Time as Actual_Time,convert(varchar,DA.Estimated_Date,103) as Estimated_Date,                     
JB.User_Id ,DA.Wrk_Status from  LMS_Tbl_DailyActivity DA                    
inner join LMS_Tbl_JobDiary JB on DA.JobDiary_Id=JB.JobDairy_Id                    
where JB.Status=0 and DA.Status=0 and JB.User_Id=299 and JB.Date=''2017/03/24''                        
order by Date                    
                
                
                
                
                    
                              
END
    ')
END
