IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_MatrixNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Get_MatrixNo](@Matrixno varchar(max))  
as  
begin  
select * from tbl_candidate_personal_det where IDMatrixNo = @Matrixno;  
  
end 
    ')
END;
