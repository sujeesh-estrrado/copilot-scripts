IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Levelsby_faculty]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[Sp_Get_Levelsby_faculty]  --1,15,0,0             
(         
@flag bigint=0,      
@Course_Level_Id bigint=0 ,        
@Programme_Id bigint=0,      
@modeofstudy bigint=0      
)      
as                  
begin                  
   if(@flag=0)      
   begin      
  select distinct C.Course_Category_Name,C.Course_Category_Id from  dbo.Tbl_Department AS D LEFT  JOIN            
               
    dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = D.Program_Type_Id LEFT  JOIN            
    dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId            
    where Online_checkstatus=1 and C.Course_Category_Id is not null and D.Delete_Status=0         
    and CL.Course_Level_Status=0 and CL.Delete_Status=0 and         
    C.Course_Category_Status=0 and C.Delete_Status=0 and        
     D.Department_Status=0 and CL.Course_Level_Id=@Course_Level_Id          
   end         
        
     if(@flag=1)      
   begin      
  select distinct C.Course_Category_Name,C.Course_Category_Id from  dbo.Tbl_Department AS D LEFT  JOIN            
               
    dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = D.Program_Type_Id LEFT  JOIN            
    dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId            
    where Online_checkstatus=1 and C.Course_Category_Id is not null and D.Delete_Status=0         
    and CL.Course_Level_Status=0 and CL.Delete_Status=0 and         
    C.Course_Category_Status=0 and C.Delete_Status=0 and        
     D.Department_Status=0 and (CL.Course_Level_Id=@Course_Level_Id or @Course_Level_Id=0) and (Modeofstudy=@modeofstudy or @modeofstudy=0)       
     and (@Programme_Id=0 or D.Department_Id=@Programme_Id)        
   end       
end 


    ')
END
