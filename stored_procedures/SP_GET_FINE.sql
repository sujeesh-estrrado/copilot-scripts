IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_FINE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_GET_FINE]-- 119,''Tution Fee-Year1'',1                
                
(@Candidate_Id bigint,@ItemDesc varchar(100),                    
@FeeHead bigint)--,@AuthorityUserId bigint)                  
AS                
BEGIN                
                
        select isnull( sum(Waived),0) as Waived  from dbo.Tbl_Fee_Entry where  Candidate_Id=@Candidate_Id and ItemDesc= @ItemDesc and FeeHeadId=@FeeHead    
end  

   ')
END;
