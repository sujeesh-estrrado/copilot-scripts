-- Check if the procedure 'Get_department' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_department]
  @Category_Id bigint
  as
  begin
               
  Select distinct D.Department_Id,D.Department_Name,D.Department_Descripition,D.Course_Code,          
       C.Program_Code,CD.ProviderId,PM.ProviderCode ,C.Course_Category_Id,D.Intro_Date,CL.Course_Level_Name          
                 
   from  Tbl_Department D
    left join  Tbl_Course_Department CD on CD.Department_Id=D.Department_Id          
    left join Tbl_ProviderMaster PM on PM.ProviderId=CD.ProviderId        
    left join Tbl_Course_Category C on C.Course_Category_Id=CD.Course_Category_Id   
        left join  Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId 
        inner join  dbo.Tbl_Course_Seat_TotalCapacity cst on cst.Category_Id= c.Course_Category_Id               
                
   where D.Department_Status=0 and cst.Category_Id=@Category_Id order by D.Department_Name desc    
   end
    ')
END;
GO
