IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ManPower_CrossTeachingList]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_ManPower_CrossTeachingList] --1  
    @Manpower_Id BIGINT  
    AS  
    BEGIN  
        SELECT 
            C.[ID] AS CrossTeaching_Id,
            C.[Manpower_Id],
            C.[Programme_Id],
            C.[YearOfStudy],
            C.[Number_New_Academic_Staff],
            C.[Other_Department_Id],
            (
                CONVERT(VARCHAR(50), C.[Period_Of_Cross_Teaching_From_Month]) + '' '' +
                CONVERT(VARCHAR(50), C.[Period_Of_Cross_Teaching_From_Year]) + '' to '' +
                CONVERT(VARCHAR(50), C.[Period_Of_Cross_Teaching_To_Month]) + '' '' +
                CONVERT(VARCHAR(50), C.[Period_Of_Cross_Teaching_To_Year])
            ) AS Period_of_Cross_Teaching_and_Duration,
            C.[Teaching_Load],
            D.[Department_Name] AS Program
        FROM 
            [dbo].[Tbl_ManPower_CrossTeaching] C  
            LEFT JOIN [dbo].[Tbl_Department] D ON D.Department_Id = C.[Programme_Id]  
        WHERE 
            [Manpower_Id] = @Manpower_Id AND [Del_Status] = 0  
    END
    ')
END
