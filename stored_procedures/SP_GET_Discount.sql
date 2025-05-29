IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_Discount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_GET_Discount]-- 119,''Tution Fee-Year1'',1                
                
(@Candidate_Id bigint,@ItemDesc varchar(100),                    
@FeeHead bigint)--,@AuthorityUserId bigint)                  
AS                
BEGIN                
                
        select  isnull(sum(Discount),0) as Discount from dbo.Tbl_Fee_Entry where  Candidate_Id=@Candidate_Id and ItemDesc= @ItemDesc and FeeHeadId=@FeeHead    
end

   ')
END;
