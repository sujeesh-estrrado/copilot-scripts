IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_SponsorshipPaymentLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_SponsorshipPaymentLog] --3,47,1,0,'''',0          
(          
@flag bigint=0,          
@StudentID bigint=0,          
@SponsorID bigint=0,          
@SponsorshipID bigint=0,          
@DateOfTransaction date='''',          
@Amount decimal(18, 2)=0          
)          
as          
begin    
    
 if(@flag=1)          
 begin          
          
  INSERT INTO Tbl_SponsorshipPaymentLog          
    (StudentID,SponsorID,SponsorshipID,DateOfTransaction,Amount,deleteStatus)          
  VALUES          
           (@StudentID,@SponsorID,@SponsorshipID,getdate(),@Amount,''false'')          
          
 end          
 else if(@flag=2)          
 begin          
  SELECT [id],[StudentID],[SponsorID],[SponsorshipID],[DateOfTransaction],[Amount],[deleteStatus]          
          
  FROM [dbo].[Tbl_SponsorshipPaymentLog]          
  where [deleteStatus] = 0 and (StudentID = @StudentID or  @StudentID =0)          
    and (SponsorID = @SponsorID or @SponsorID =0)          
    and (SponsorshipID = @SponsorshipID or @SponsorshipID =0)          
 end          
 else if(@flag=3)          
 begin        
   
     
  SELECT coalesce( SUM(Amount),0) as AmountPaid          
  FROM [dbo].[Tbl_SponsorshipPaymentLog]          
  where [deleteStatus] = 0 and (StudentID = @StudentID or @StudentID =0)          
    and (SponsorID = @SponsorID or @SponsorID =0)          
    and (SponsorshipID = @SponsorshipID or @SponsorshipID =0)          
         
    
      
 end   
   
end 
    ')
END;
