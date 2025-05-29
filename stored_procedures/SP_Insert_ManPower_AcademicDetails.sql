IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ManPower_AcademicDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE pROCEDURE [dbo].[SP_Insert_ManPower_AcademicDetails]  
@Manpower_Id bigint,  
@Programme_Id bigint,  
@yearOfStudy bigint,  
@Qualification varchar(max),  
@SpecializationArea varchar(max),  
@TeachingchExperience bigint,  
@IndustryExperience bigint,  
@Skills varchar(max),  
@Traits varchar(max),  
@Academic_Id bigint  
  
AS  
 DECLARE @RET_ID BIGINT  
BEGIN  
IF(@Academic_Id>0)  
 BEGIN  
  UPDATE [dbo].[Tbl_ManPower_Academic] SET [Programme_Id]= @Programme_Id ,[YearOfStudy] = @yearOfStudy,[Qulification_Required]= @Qualification  
  ,[AreaOfSpecialization]= @SpecializationArea,[Minimum_YearOfTeaching_Experience]=@TeachingchExperience  
    ,[Minimum_YearOf_Industrial_Experience]= @IndustryExperience ,[Knowledge_And_Skill] =@Skills,[Traits_Required]= @Traits   
    ,[Update_Date]=GETDATE()   
    WHERE [ID]=@Academic_Id  
    SET @RET_ID=@Manpower_Id  
 END  
 ELSE  
  BEGIN  
  INSERT INTO [dbo].[Tbl_ManPower_Academic](  
    [Manpower_Id]  ,[Programme_Id]  ,[YearOfStudy]  ,[Qulification_Required] ,[AreaOfSpecialization] ,[Minimum_YearOfTeaching_Experience]  ,  
    [Minimum_YearOf_Industrial_Experience]  ,[Knowledge_And_Skill] ,[Traits_Required]  ,  
    [Create_Date] ,[Update_Date]  ,[Del_Status])  
   VALUES(   
    @Manpower_Id,@Programme_Id,@yearOfStudy,@Qualification,@SpecializationArea  
    ,@TeachingchExperience,@IndustryExperience,@Skills,@Traits  
    ,GETDATE(),'''',0)  
    SET @RET_ID= @Manpower_Id  
  END  
  SELECT @RET_ID  
END  

   ')
END;
