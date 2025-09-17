! --------------------------------------------- !
! Search commercial value for a resistor        !
! Check for combination in series and parallel  !
! --------------------------------------------- !
! GNU Fortran (tdm64-1) 10.3.0 on Windows 11    !
! Author: Fabiano Costa Sep/16/2025             !
! --------------------------------------------- !
 
program resistores
    implicit none

    integer :: idx, idy, x, rr, pair1, pair2
    real    :: res(193)
    real    :: rv
    real    :: rbase(24) = [0.1, 0.11, 0.12, 0.13, 0.15, 0.16, 0.18, 0.2,    &
                           & 0.22, 0.24, 0.27, 0.3,  0.33, 0.36, 0.39, 0.43, &
                           & 0.47, 0.51, 0.56, 0.62, 0.68, 0.75, 0.82, 0.91]
    
    call fill_commercial_array

    write(*,'(/, A)', advance="no") 'Enter resistor value in Ohms: '
    read(*,*) rv
    write(*,'(/, A)') 'Nearest commercial value'
    write(*,'(A)', advance="no") 'R  = '
    rr = commercialNearest(rv)
    call showRes(res(rr))
    call searchPairSeries (rv)

    write(*,'(/, A)') 'Closest value using two resistors in series'
    write(*,'(A)', advance="no") 'R1 = '
    call showRes(res(pair1))
    write(*,'(A)', advance="no") 'R2 = '
    call showRes(res(pair2))
    write(*,'(A)') '------------------'
    write(*,'(A)', advance="no") 'R  = '
    call showRes(res(pair1) + res(pair2))

    call searchPairParallel (rv)
    write(*,'(/, A)') 'Closest value using two resistors in parallel'
    write(*,'(A)', advance="no") 'R1 = '
    call showRes(res(pair1))
    write(*,'(A)', advance="no") 'R2 = '
    call showRes(res(pair2))
    write(*,'(A)') '------------------'
    write(*,'(A)', advance="no") 'R  = '
    call showRes((res(pair1) * res(pair2))/(res(pair1) + res(pair2)))
    write(*,*)    


    !! End main code


    contains
    
    subroutine fill_commercial_array()
        ! Fill "res" array with all commercial values possible for 5% tolerance
        x = 1
        do idy = 1, 24
            res(x) = rbase(idy)
            x = x + 1
            do idx = 2, 8
                res(x) = res(x-1) * 10.0
                x = x + 1
            end do
        end do
        res(193) = 10000000.0 
    end subroutine

    subroutine showRes( resValue )
        implicit none
        real :: val
        character :: shwRes
        real, intent(in) :: resValue
        if (resValue < 1000) then
            val = resValue 
            shwRes = 'R'
        else if (resValue <= 999999) then
            val = resValue / 1000
            shwRes = 'K'
        else 
            val = resValue / 1000000
            shwRes = 'M'
        end if
        write(*,'(F11.2, 1X, A)') val, shwRes
    end subroutine showRes

    integer function commercialNearest( resValue )
        real, intent(in) :: resValue
        real :: difference, actualdifference
        integer :: idx
        
        commercialNearest = 1

        difference = abs(res(1) - resValue)
        do idx = 2, 193
            actualdifference = abs(res(idx) - resValue)
            if (actualdifference < difference) then
                difference = actualdifference
                commercialNearest = idx
            end if
        end do 
    end function commercialNearest

    subroutine searchPairSeries( resValue )
        real, intent(in) :: resValue
        real             :: difference, actualdifference
        real             :: sum

        pair1 = 0
        pair2 = 0

        difference = huge(1.0)
        do idx = 1, 193
            do idy = idx+1, 193
                sum = res(idx) + res(idy)
                actualdifference = abs(sum - resValue)
                if (actualdifference < difference) then
                    difference = actualdifference
                    pair1 = idx
                    pair2 = idy
                end if
            end do
        end do
    end subroutine searchPairSeries

    subroutine searchPairParallel( resValue )
        real, intent(in) :: resValue
        real             :: difference, actualdifference
        real             :: equivalent

        pair1 = 0
        pair2 = 0

        difference = huge(1.0)
        do idx = 1, 193
            do idy = idx+1, 193
                equivalent = (res(idx) * res(idy)) / (res(idx) + res(idy)) 
                actualdifference = abs(equivalent - resValue)
                if (actualdifference < difference) then
                    difference = actualdifference
                    pair1 = idx
                    pair2 = idy
                end if
            end do
        end do
    end subroutine searchPairParallel

end program resistores