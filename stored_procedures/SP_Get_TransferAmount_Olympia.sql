IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_TransferAmount_Olympia]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_TransferAmount_Olympia]
            @Candidate_Id BIGINT
        AS
        BEGIN
            SELECT DISTINCT
                cdm.Duration_Mapping_Id,
                cbd.Batch_Code + ''-'' + cs.Semester_Code AS batch,
                FH.Fee_Head_Id,
                FH.Fee_Head_Name,
                FPSD.Amount,
                cbd.Batch_Id,
                SS.Candidate_Id,
                FEM.ItemDescription,
                FEM.typ,
                fsmp.Feecode,
                FEM.Paid AS amountpaid,
                FEM.Amount - FEM.Paid AS balance,
                SS.Student_Semester_Id
            FROM dbo.Tbl_Course_Duration_Mapping cdm
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails cdpd ON cdm.Duration_Period_Id = cdpd.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdpd.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester cs ON cdpd.Semester_Id = cs.Semester_Id
            INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Fee_Entry FPSD ON FPSD.Candidate_Id = SS.Candidate_Id AND FPSD.IntakeId = cbd.Batch_Id
            INNER JOIN dbo.Tbl_Fee_Entry_Main FEM ON FEM.Candidate_Id = SS.Candidate_Id AND FEM.IntakeId = cbd.Batch_Id AND FEM.FeeHeadId = FPSD.FeeHeadId AND FEM.Amount = FPSD.Amount
            INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id = FPSD.FeeHeadId
            INNER JOIN dbo.Tbl_FeecodeStudentMap fsmp ON fsmp.Candidate_Id = SS.Candidate_Id AND fsmp.Intake_Id = cbd.Batch_Id
            WHERE SS.Candidate_Id = @Candidate_Id

            UNION

            SELECT DISTINCT
                cdm.Duration_Mapping_Id,
                cbd.Batch_Code + ''-'' + cs.Semester_Code AS batch,
                FH.Fee_Head_Id,
                FH.Fee_Head_Name,
                FSD.Amount,
                cbd.Batch_Id,
                SS.Candidate_Id,
                FSD.ItemDescription,
                ''Normal'' AS typ,
                fsmp.Feecode,
                ISNULL(FEM.Paid, 0) AS amountpaid,
                FSD.Amount - ISNULL(FEM.Paid, 0) AS balance,
                SS.Student_Semester_Id
            FROM dbo.Tbl_Course_Duration_Mapping cdm
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails cdpd ON cdm.Duration_Period_Id = cdpd.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdpd.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester cs ON cdpd.Semester_Id = cs.Semester_Id
            INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id AND SS.Student_Semester_Current_Status = 1
            INNER JOIN dbo.Tbl_FeecodeStudentMap fsmp ON fsmp.Candidate_Id = SS.Candidate_Id AND fsmp.Intake_Id = cbd.Batch_Id
            INNER JOIN dbo.Tbl_Fee_Settings FS ON FS.Scheme_Code = fsmp.Feecode
            INNER JOIN dbo.TBL_FeeSettingsDetails fsd ON fsd.Fee_Settings_Id = fs.Fee_Settings_Id
            INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id = FSD.Feehead_Id
            LEFT JOIN dbo.Tbl_Fee_Entry_Main FEM ON FEM.ItemDescription = FSD.ItemDescription AND FEM.FeeHeadId = FSD.Feehead_Id AND FEM.Amount = FSD.Amount AND FEM.Candidate_Id = @Candidate_Id
            WHERE SS.Candidate_Id = @Candidate_Id AND ISNULL(FEM.Paid, 0) = 0

            UNION

            SELECT DISTINCT
                cdm.Duration_Mapping_Id,
                cbd.Batch_Code + ''-'' + cs.Semester_Code AS batch,
                FH.Fee_Head_Id,
                FH.Fee_Head_Name,
                fcd.Amount,
                cbd.Batch_Id,
                SS.Candidate_Id,
                fcd.ItemDescription,
                ''Compulsory'' AS typ,
                fsmp.Feecode,
                ISNULL(FEM.Paid, 0) AS amountpaid,
                fcd.Amount - ISNULL(FEM.Paid, 0) AS balance,
                SS.Student_Semester_Id
            FROM dbo.Tbl_Course_Duration_Mapping cdm
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails cdpd ON cdm.Duration_Period_Id = cdpd.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdpd.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester cs ON cdpd.Semester_Id = cs.Semester_Id
            INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id AND SS.Student_Semester_Current_Status = 1
            INNER JOIN dbo.Tbl_FeecodeStudentMap fsmp ON fsmp.Candidate_Id = SS.Candidate_Id AND fsmp.Intake_Id = cbd.Batch_Id
            INNER JOIN dbo.Tbl_Fee_Compulsory fc ON fc.CourseId = fsmp.Course_Id
            INNER JOIN dbo.Tbl_Fee_CompulsoryDetails fcd ON fcd.CumpulsoryFeeId = fc.CompulsoryFeeId
            INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id = fcd.FeeHeadId
            LEFT JOIN dbo.Tbl_Fee_Entry_Main FEM ON FEM.ItemDescription = fcd.ItemDescription AND FEM.FeeHeadId = fcd.FeeHeadId AND FEM.Amount = fcd.Amount AND FEM.Candidate_Id = @Candidate_Id
            WHERE SS.Candidate_Id = @Candidate_Id 
                AND fc.TypeOfStudent = (SELECT TypeOfStudent FROM Tbl_Candidate_Personal_Det cp WHERE cp.Candidate_Id = @Candidate_Id)
                AND ISNULL(FEM.Paid, 0) = 0
        END
    ')
END
