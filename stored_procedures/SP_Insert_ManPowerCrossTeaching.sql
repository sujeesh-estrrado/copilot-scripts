IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ManPowerCrossTeaching]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_ManPowerCrossTeaching]  
@Manpower_Id bigint,  
@Programme_Id bigint,  
@yearOfStudy bigint,  
@NumberofStaffs bigint,  
@OtherDept_Id bigint,  
@Period_Of_CrossTeach_From_Month varchar(max),  
@Period_Of_CrossTeach_From_Year bigint,  
@Period_Of_CrossTeach_To_Month varchar(max),  
@Period_Of_CrossTeach_To_Year bigint,  
@TeachingLoad bigint,  
@CrossTeaching_Id bigint  
AS  
DECLARE @ID BIGINT  
BEGIN  
 IF(@CrossTeaching_Id>0)  
 BEGIN  
  UPDATE [dbo].[Tbl_ManPower_CrossTeaching]  
  SET [Programme_Id] = @Programme_Id,[YearOfStudy] = @yearOfStudy,[Number_New_Academic_Staff] =@NumberofStaffs ,[Other_Department_Id] =@OtherDept_Id   
  ,[Period_Of_Cross_Teaching_From_Month] =@Period_Of_CrossTeach_From_Month  
      ,[Period_Of_Cross_Teaching_From_Year] = @Period_Of_CrossTeach_From_Year  
      ,[Period_Of_Cross_Teaching_To_Month] = @Period_Of_CrossTeach_To_Month  
      ,[Period_Of_Cross_Teaching_To_Year] = @Period_Of_CrossTeach_To_Year  
      ,[Teaching_Load] = @TeachingLoad  
      ,[UpdateDate] = GETDATE()  
   WHERE [Manpower_Id]=@Manpower_Id AND [ID]=@CrossTeaching_Id  
   SET @ID=@Manpower_Id  
 END  
 ELSE  
 BEGIN  
  INSERT INTO [dbo].[Tbl_ManPower_CrossTeaching]([Manpower_Id],[Programme_Id],[YearOfStudy],[Number_New_Academic_Staff],[Other_Department_Id]  
           ,[Period_Of_Cross_Teaching_From_Month],[Period_Of_Cross_Teaching_From_Year],[Period_Of_Cross_Teaching_To_Month],[Period_Of_Cross_Teaching_To_Year]  
           ,[Teaching_Load],[CreateDate],[UpdateDate],[Del_Status])  
     VALUES (@Manpower_Id,@Programme_Id,@yearOfStudy,@NumberofStaffs,@OtherDept_Id  
   ,@Period_Of_CrossTeach_From_Month,@Period_Of_CrossTeach_From_Year,@Period_Of_CrossTeach_To_Month,@Period_Of_CrossTeach_To_Year  
   ,@TeachingLoad,GETDATE(),'''',0)  
   SET @ID=@Manpower_Id  
 END  
   
   SELECT @ID  
END

   ')
END;
