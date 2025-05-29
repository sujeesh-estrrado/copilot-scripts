IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_FeeStructure]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_FeeStructure] --0,2  
    (  
        @flag BIGINT = 0,  
        @Intake_Id BIGINT = 0,  
        @Stud_Id BIGINT = 0,  
        @StudType VARCHAR(50) = ''''  
    )            
    AS              
    BEGIN   
        -- For Candidate fee details  
        IF (@flag = 0)  
        BEGIN  
            IF (RTRIM(LTRIM(@StudType)) = ''INTERNATIONAL'')  
            BEGIN   
                SELECT 
                    accountcodeid,
                    amountlocal,
                    amountintl,
                    FI.groupid,
                    MinAdmissionAmountInter AS MinAdmissionAmount,
                    CASE 
                        WHEN semester = -1 THEN ''ApplicationFee''
                        WHEN semester = 0 THEN ''Initial Fee''
                        ELSE CONCAT(''Semester '', semester) 
                    END AS semester,
                    name  
                FROM 
                    fee_group FG  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    programIntakeID = @Intake_Id 
                    AND FG.active = 1   
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND Promotional = 0  
                ORDER BY 
                    semester   
            END  
            ELSE IF (RTRIM(LTRIM(@StudType)) = ''LOCAL'')  
            BEGIN  
                SELECT 
                    accountcodeid,
                    amountlocal,
                    amountintl,
                    FI.groupid,
                    MinAdmissionAmountLocal AS MinAdmissionAmount,
                    CASE 
                        WHEN semester = -1 THEN ''ApplicationFee''
                        WHEN semester = 0 THEN ''Initial Fee''
                        ELSE CONCAT(''Semester '', semester) 
                    END AS semester,
                    name  
                FROM 
                    fee_group FG  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    programIntakeID = @Intake_Id 
                    AND FG.active = 1   
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND Promotional = 0  
                ORDER BY 
                    semester  
            END  
        END  
    
        -- For Candidate Min Admission Amount  
        IF (@flag = 1)  
        BEGIN  
            IF (RTRIM(LTRIM(@StudType)) = ''INTERNATIONAL'')  
            BEGIN   
                SELECT DISTINCT 
                    MinAdmissionAmountInter AS MinAdmissionAmount  
                FROM 
                    fee_group FG  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    programIntakeID = @Intake_Id 
                    AND FG.active = 1 
                    AND ac.active = 1 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND Promotional = 0  
            END  
            ELSE IF (RTRIM(LTRIM(@StudType)) = ''LOCAL'')  
            BEGIN  
                SELECT DISTINCT 
                    MinAdmissionAmountLocal AS MinAdmissionAmount  
                FROM 
                    fee_group FG  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    programIntakeID = @Intake_Id 
                    AND FG.active = 1 
                    AND ac.active = 1 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND Promotional = 0  
            END  
        END  

        -- For Student fee details  
        IF (@flag = 2)  
        BEGIN  
            IF (RTRIM(LTRIM(@StudType)) = ''INTERNATIONAL'')  
            BEGIN   
                SELECT DISTINCT
                    accountcodeid,
                    amountlocal,
                    amountintl,
                    FI.groupid,
                    MinAdmissionAmountInter AS MinAdmissionAmount,
                    CASE 
                        WHEN semester = -1 THEN ''ApplicationFee''
                        WHEN semester = 0 THEN ''Initial Fee''
                        ELSE CONCAT(''Semester '', semester) 
                    END AS semester,
                    name,
                    FI.semester AS SemNo
                FROM 
                    tbl_Student_AccountGroup_Map AM  
                LEFT JOIN 
                    fee_group FG ON FG.groupid = AM.FeeGroupID  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    AM.StudentID = @Stud_Id 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND AM.deleteStatus = 0  
                    AND amountintl > 0
                ORDER BY 
                    FI.semester 
            END  
            ELSE IF (RTRIM(LTRIM(@StudType)) = ''LOCAL'')  
            BEGIN  
                SELECT DISTINCT
                    accountcodeid,
                    amountlocal,
                    amountintl,
                    FI.groupid,
                    MinAdmissionAmountLocal AS MinAdmissionAmount,
                    CASE 
                        WHEN semester = -1 THEN ''ApplicationFee''
                        WHEN semester = 0 THEN ''Initial Fee''
                        ELSE CONCAT(''Semester '', semester) 
                    END AS semester,
                    name,
                    FI.semester AS SemNo
                FROM 
                    tbl_Student_AccountGroup_Map AM  
                LEFT JOIN 
                    fee_group FG ON FG.groupid = AM.FeeGroupID  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    AM.StudentID = @Stud_Id 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND AM.deleteStatus = 0  
                    AND amountlocal > 0
                ORDER BY 
                    FI.semester
            END  
        END  

        -- For Student Min Admission Amount  
        IF (@flag = 3)  
        BEGIN  
            IF (RTRIM(LTRIM(@StudType)) = ''INTERNATIONAL'')  
            BEGIN   
                SELECT DISTINCT 
                    MinAdmissionAmountInter AS MinAdmissionAmount  
                FROM 
                    tbl_Student_AccountGroup_Map AM  
                LEFT JOIN 
                    fee_group FG ON FG.groupid = AM.FeeGroupID  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    AM.StudentID = @Stud_Id 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND AM.deleteStatus = 0  
            END  
            ELSE IF (RTRIM(LTRIM(@StudType)) = ''LOCAL'')  
            BEGIN  
                SELECT DISTINCT 
                    MinAdmissionAmountLocal AS MinAdmissionAmount  
                FROM 
                    tbl_Student_AccountGroup_Map AM  
                LEFT JOIN 
                    fee_group FG ON FG.groupid = AM.FeeGroupID  
                INNER JOIN 
                    fee_group_item FI ON FI.groupid = FG.groupid  
                LEFT JOIN 
                    ref_accountcode ac ON ac.id = FI.accountcodeid  
                WHERE 
                    AM.StudentID = @Stud_Id 
                    AND FG.deleteStatus = 0 
                    AND FI.deleteStatus = 0 
                    AND AM.deleteStatus = 0  
            END  
        END  
    END  
    ')
END
