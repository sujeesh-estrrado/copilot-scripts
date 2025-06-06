IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_CoursePrequisite]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_CoursePrequisite] -- 1,3,24
  (
  @Org_Id bigint,
@Faculty_Id bigint,
@Course_Prequisite bigint=0
  )
AS  
  
BEGIN  
  
 SELECT  concat(Course_Name,''-'',Course_code) as Course_Name1,* from Tbl_New_Course  where Active_Status=''Active'' and Org_Id=@Org_Id and Faculty_Id=@Faculty_Id and Delete_Status=0
 and (@Course_Prequisite=0 or Course_Id!=@Course_Prequisite)
order by  Course_Name 
     
END
    ')
END
