IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_CourseDurationNew]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Insert_CourseDurationNew] --1,1,''Years'',1.0,2.0,12.0,365.0,0
 (
          @Program_Org_Id bigint,
          @Program_Category_Id bigint,  
          @Program_Duration_Type varchar(10),  
          @Program_Duration_Year float,  
          @Program_Duration_Sem float,  
          @Program_Duration_Month float,  
          @Program_Duration_Days float,  
          @Program_Duration_DelStatus bit
  )  
AS  
IF  EXISTS (SELECT Program_Category_Id FROM Tbl_Program_Duration WHERE Program_Category_Id=@Program_Category_Id and Program_Duration_DelStatus=0)  
BEGIN  
  RAISERROR (''Data Already exists.'', -- Message text.  
               16, -- Severity.  
               1 -- State.  
               );  
END  
ELSE  
BEGIN  
  
INSERT INTO dbo.Tbl_Program_Duration(Program_Org_Id,Program_Category_Id,Program_Duration_Type,Program_Duration_Year,  
Program_Duration_Sem,Program_Duration_Month,Program_Duration_Days,Program_Duration_DelStatus,Created_date,Updated_date,Delete_Status)  
  
VALUES(@Program_Org_Id,@Program_Category_Id,@Program_Duration_Type,@Program_Duration_Year,  
@Program_Duration_Sem,@Program_Duration_Month,@Program_Duration_Days,@Program_Duration_DelStatus,getdate(),getdate(),0)  
  
  
END

--select * from Tbl_Program_Duration
    ')
END
GO