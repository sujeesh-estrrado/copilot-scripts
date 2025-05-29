IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Departement_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Departement_By_Id] -- 1    
@Batch_id Bigint      
AS      
BEGIN        
 
 select A.Program_Category_Id from Tbl_Program_Duration A
 inner join Tbl_Course_Batch_Duration b on b.Duration_Id=A.Duration_Id
 where b.Batch_Id=@Batch_id       
 
 
 END  
	');
END;
