IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Hostel_Registration]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_Insert_Hostel_Registration]        
(@HostelName varchar(50),        
@HostelAddress varchar(max),        
@HostelLocation varchar(50),              
@Mobile bigint,        
@phone bigint,        
@Category varchar(30),        
@HostelCode varchar(30),        
@Date datetime,        
@Status bit)        
        
AS       
IF  EXISTS (SELECT * FROM Tbl_HostelRegistration WHERE Hostel_Address=@HostelAddress or Phone=@phone or Hostel_Code=@HostelCode)            
            
BEGIN            
RAISERROR(''Data Already Exist.'',16,1);            
END            
ELSE       
BEGIN        
INSERT INTO Tbl_HostelRegistration        
            (Hostel_Name        
           ,Hostel_Address        
           ,Hostel_Location             
           ,Mobile        
           ,Phone        
           ,Category        
           ,Hostel_Code        
           ,Hostel_Delete_Status        
           ,Insert_Date)        
     VALUES        
           (@HostelName, @HostelAddress,        
            @HostelLocation,       
            @Mobile,@phone,@Category,@HostelCode,@Status,@Date)        
        
        
END


   ')
END;
