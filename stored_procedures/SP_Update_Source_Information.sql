IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Source_Information]') 
    AND type = N'P'
)
BEGIN
    EXEC('

create procedure [dbo].[SP_Update_Source_Information]            
(@Agent_Id bigint,
@recruitedby_other varchar(Max),
@Candidate_Id bigint
)              
              
as              
              
BEGIN              
              
Update Tbl_Candidate_Personal_Det set Agent_Id=@Agent_Id,
recruitedby_other=@recruitedby_other where Candidate_Id=@Candidate_Id
end  
    ')
END
