IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ManPower_CrossTeachingDetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create PROCEDURE [dbo].[SP_Get_ManPower_CrossTeachingDetails] --1,1  
 @Manpower_Id bigint,  
 @Programme_Id bigint  
AS  
BEGIN  
 SELECT C.[ID] AS CrossTeaching_Id,C.[Manpower_Id],C.[Programme_Id],C.[YearOfStudy] ,C.[Number_New_Academic_Staff],C.[Other_Department_Id]  
 ,C.[Period_Of_Cross_Teaching_From_Month],C.[Period_Of_Cross_Teaching_From_Year],C.[Period_Of_Cross_Teaching_To_Month],C.[Period_Of_Cross_Teaching_To_Year]  
 ,C.[Teaching_Load]  
 ,D.[Department_Name] AS Program  
       
 FROM [dbo].[Tbl_ManPower_CrossTeaching] C  
   LEFT JOIN [dbo].[Tbl_Department] D ON D.Department_Id= C.[Programme_Id]  
   WHERE [Manpower_Id]=@Manpower_Id AND C.[ID]=@Programme_Id  
END

    ')
END
