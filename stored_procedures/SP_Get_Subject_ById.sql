IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Subject_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Subject_ById]--1
(@Subject_Id bigint)        
AS        
        
BEGIN           
 SELECT B.Subject_Id,      
 B.Subject_Name,B.Assessment_Code,     
 B.Parent_Subject_Id,        
 ISNULL((select Subject_Name from Tbl_Subject  where Subject_Id=B.Parent_Subject_Id), '''''''') AS [Parent Subject],        
           B.Subject_Code,B.Subject_Descripition,B.Subject_Date         
  FROM Tbl_Subject B        
        LEFT JOIN Tbl_Subject A on A.Subject_Id=B.Subject_Id          
where B.Subject_Status=0 and B.subject_Id=@Subject_Id           
           
END
    ')
END
