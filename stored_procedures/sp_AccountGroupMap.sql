IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_AccountGroupMap]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_AccountGroupMap]
        @flag INT = 0,
        @id BIGINT = 0,
        @StudentID BIGINT = 0,
        @FeeGroupID BIGINT = 0,
        @FeeGroupCode VARCHAR(50) = '''',
        @ProgrmID BIGINT = 0,
        @programIntakeID BIGINT = 0,
        @Promotion BIT = 0,
        @PromoPercentage DECIMAL(18, 0) = 0,
        @deleteStatus BIT = 0,
        @StudType VARCHAR(50) = ''''
        AS
        BEGIN
            IF @flag = 1 -- Insert new Student_AccountGroup_Map
            BEGIN
                INSERT INTO tbl_Student_AccountGroup_Map 
                ([StudentID], [FeeGroupID], [FeeGroupCode], [ProgrmID], [programIntakeID], [Promotion],
                [PromoPercentage], [deleteStatus], [createdDate], [StudType])
                VALUES (@StudentID, @FeeGroupID, @FeeGroupCode, @ProgrmID, @programIntakeID, @Promotion,
                        @PromoPercentage, 0, GETDATE(), @StudType);
            END

            IF @flag = 2 -- Get all Fee Group Mappings
            BEGIN
                SELECT [id], [StudentID], [FeeGroupID], [FeeGroupCode], [ProgrmID], [programIntakeID],
                       [PromoPercentage], [deleteStatus], [createdDate], [StudType]
                FROM [dbo].[tbl_Student_AccountGroup_Map]
                WHERE [deleteStatus] = 0;
            END

            IF @flag = 3 -- Get Fee Group Mapping by StudentID
            BEGIN
                SELECT [id], [StudentID], [FeeGroupID], [FeeGroupCode], [ProgrmID], [programIntakeID],
                       [PromoPercentage], [deleteStatus], [createdDate], [StudType]
                FROM [dbo].[tbl_Student_AccountGroup_Map]
                WHERE [deleteStatus] = 0 AND [StudentID] = @StudentID;
            END

            IF @flag = 4 -- Update Fee Group Mapping
            BEGIN
                UPDATE tbl_Student_AccountGroup_Map
                SET [FeeGroupID] = @FeeGroupID, [FeeGroupCode] = @FeeGroupCode
                WHERE [deleteStatus] = 0 AND [StudentID] = @StudentID;
            END

            IF @flag = 5 -- Get Fee Group Mapping Count by FeeGroupID
            BEGIN
                SELECT [id], [StudentID], [FeeGroupID], [FeeGroupCode], [ProgrmID], [programIntakeID],
                       [PromoPercentage], [deleteStatus], [createdDate], [StudType]
                FROM [dbo].[tbl_Student_AccountGroup_Map]
                WHERE [deleteStatus] = 0 AND [FeeGroupID] = @FeeGroupID;
            END

            IF @flag = 6 -- Delete Fee Group Mapping (SoftDelete)
            BEGIN
                UPDATE tbl_Student_AccountGroup_Map
                SET [deleteStatus] = 0
                WHERE [id] = @id;
            END
        END
    ');
END
