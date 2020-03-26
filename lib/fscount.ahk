/*
    Directly call
    
    fsCount(start, end[, step]) or fsCount(end)
    return a enumerator to count down or up from start to end in interval of step
    The default value of the step is 1
    If start is omitted, the default value to it is 0
    
    In a for loop, the second parameter makes non-sence to fsCount function.
    Thus, the value of it will be always the value of step.

    For a positive step, the contents of a count c are determined by 
    the formula c[i] = start + step*i where i >= 0 and c[i] < stop.

    For a negative step, the contents of the count are still determined by 
    the formula c[i] = start + step*i, but the constraints are i >= 0 and c[i] > stop.
    
    Examples:
        list := []

        for k in fsCount(10)
            list.Push[k]
        ; list -> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        for k in fsCount(1, 11)
            list.Push[k]
        ; list -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for k in fsCount(0, 10, 3)
            list.Push[k]
        ; list -> [0, 3, 6, 9]

        for k in fsCount(0, -10, -1)
            list.Push[k]
        ; list -> [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]

        for k in fsCount(10, 0, -1)
            list.Push[k]
        ; list -> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

        for k in fsCount(0)
            list.Push[k]
        ; list -> []

        for k in fsCount(1, 0)
            list.Push[k]
        ; list -> []
*/
fsCount(start, end := "", step := 1)
{
    if (end == "")
        return new __ClASS_AHKFS_ITERATION(0, start, step)
    return new __ClASS_AHKFS_ITERATION(start, end, step)
}

class __ClASS_AHKFS_ITERATION
{
    __New(start, end, step)
    {
        this.start := start, this.end := end, this.step := step
    }

    class Enumerator
    {
        __New(start, end, step)
        {
            local
            this.start := start, this.end := end, this.step := step
            return this
        }

        Next(ByRef Key, ByRef Value := "")
        {
            local
            if ((this.end-this.start)*this.step > 0)
            {
                Key := this.start
                Value := this.step
                this.start += this.step
                return Value
            }
        }
    }

    _NewEnum()
    {
        return new __ClASS_AHKFS_ITERATION.Enumerator(this.start, this.end, this.step)
    }
}
