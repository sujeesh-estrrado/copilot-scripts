IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_Program_Not_Duration_Mapped]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_get_Program_Not_Duration_Mapped] --1
 @Org_Id bigint  
As
Begin
   Select  Department_Id,Course_Code,Department_Name from Tbl_Department where Department_Status=0 and 
   Active_Status=''Active'' and Delete_Status=0 and Department_Id not in(SELECT  D.Department_Id
							FROM            dbo.Tbl_Program_Duration AS PD INNER JOIN
													 dbo.Tbl_Organzations AS O ON O.Organization_Id = PD.Program_Org_Id LEFT OUTER JOIN
													 dbo.Tbl_Department AS D ON D.Department_Id = PD.Program_Category_Id
							WHERE        (PD.Program_Duration_DelStatus = 0) AND (D.Department_Status = 0))
   
End
');
END;
