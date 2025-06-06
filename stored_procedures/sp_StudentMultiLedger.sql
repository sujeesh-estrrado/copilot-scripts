IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentMultiLedger]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_StudentMultiLedger]-- 1,55731            
--[sp_StudentMultiLedger]1,55731            
(            
@Flag bigint =0,            
@StudentID bigint=0            
            
)            
as            
begin    
          
 if(@Flag=1)            
 begin            
  
       
  select studentid, courseid, CONCAT(D.Course_Code,''-'',D.Department_Name) as Programme  from student_transaction st            
  left join Tbl_Department D on st.courseid = D.Department_Id             
  group by courseid,studentid,Course_Code,Department_Name            
  having studentid= @StudentID and courseid<>0            
          
   
 end      
  
end 
    ')
END
