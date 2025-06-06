IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_ContactDet_Personal]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Update_Candidate_ContactDet_Personal]
(@Candidate_Id bigint,@Candidate_PermAddress varchar(max),        
@Candidate_ContAddress varchar(max),@Candidate_Telephone varchar(50),@Candidate_Mob1 varchar(50),
@Candidate_Mob2 varchar(50),@Candidate_Email varchar(50),

 @Candidate_PermAddress_Line2  varchar(max),    
@Candidate_PermAddress_postCode  varchar(max),
@Candidate_PermAddress_Country BIGINT,
@Candidate_PermAddress_State     varchar(max),
@Candidate_PermAddress_City varchar(max),
@Candidate_ContAddress_Line2 varchar(max),
@Candidate_ContAddress_postCode varchar(max),
@Candidate_ContAddress_Country BIGINT,
@Candidate_ContAddress_State varchar(max),
@Candidate_ContAddress_City varchar(max)

 )        
        
        
         
AS        
BEGIN        
UPDATE Tbl_Candidate_ContactDetails        
SET        
   
Candidate_PermAddress=@Candidate_PermAddress,        
Candidate_ContAddress=@Candidate_ContAddress,        
Candidate_Telephone=@Candidate_Telephone,        
Candidate_Mob1=@Candidate_Mob1,        
Candidate_Mob2=@Candidate_Mob2,        
Candidate_Email=@Candidate_Email,        


 Candidate_PermAddress_Line2=@Candidate_PermAddress_Line2,  
Candidate_PermAddress_postCode=@Candidate_PermAddress_postCode,
Candidate_PermAddress_Country=@Candidate_PermAddress_Country,
Candidate_PermAddress_State=@Candidate_PermAddress_State,   
Candidate_PermAddress_City=@Candidate_PermAddress_City,
Candidate_ContAddress_Line2=@Candidate_ContAddress_Line2,
Candidate_ContAddress_postCode=@Candidate_ContAddress_postCode,
Candidate_ContAddress_Country=@Candidate_ContAddress_Country,
Candidate_ContAddress_State=@Candidate_ContAddress_State,
Candidate_ContAddress_City=@Candidate_ContAddress_City

WHERE @Candidate_Id=Candidate_Id        
        
END     
    ')
END
