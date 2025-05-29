IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Fee_Entry_Detail_insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Fee_Entry_Detail_insert] --159,11830,4            
@CandidateId bigint              
,@InTakeId bigint         
--,@ReceiptNo bigint             
          
            
AS            
begin           
    Declare @ID bigint           
    Declare @cnt bigint          
    set @cnt= (select count(Fee_Entry_Details_Id) from Tbl_Fee_Entry_Details where CandidateId=@CandidateId and IntakeId=@InTakeId)          
    if(@cnt>0)          
    begin          
        set @ID=(select Fee_Entry_Details_Id from Tbl_Fee_Entry_Details where CandidateId=@CandidateId and IntakeId=@InTakeId)          
    end          
    else          
    begin         
    INSERT INTO Tbl_Fee_Entry_Details              
           (            
           CandidateId              
           ,IntakeId          
           --,ReceiptNo           
                      
           )              
     VALUES              
           (@CandidateId              
           ,@InTakeId         
           --,@ReceiptNo             
                   
           )            
    set @ID =(select Scope_identity())          
                  
                     
    END          
select @ID          
end

   ')
END;
