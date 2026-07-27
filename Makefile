FFLAGS    = -C -g -w -fno-automatic -fbounds-check -ffixed-line-length-132
F77       :=gfortran
########################################

externals_all_objs = externals_all.o sigmodel_calc_hybrid_v3.o F1F209.o \
                     get_cc_info.o F1F2IN21_v1.0.o dilog64.o emcfit_xem2.o
externals_all_srcs = externals_all.f sigmodel_calc_hybrid_v3.f F1F209.f \
                     get_cc_info.f F1F2IN21_v1.0.f dilog64.f emcfit_xem2.f

########################################

none: externals_all

all:  externals_all

externals_all.o: externals_all.f
		 $(F77) $(FFLAGS) -c $< -o $@

sigmodel_calc_hybrid_v3.o: sigmodel_calc_hybrid_v3.f
	$(F77) $(FFLAGS) -c $< -o $@

F1F209.o: F1F209.f
	$(F77) $(FFLAGS) -c $< -o $@

F1F2IN21_v1.0.o: F1F2IN21_v1.0.f
	$(F77) $(FFLAGS) -c $< -o $@

get_cc_info.o: get_cc_info.f
	$(F77) $(FFLAGS) -c $< -o $@

dilog64.o: dilog64.f
	$(F77) $(FFLAGS) -c $< -o $@

emcfit_xem2.o: emcfit_xem2.f
	$(F77) $(FFLAGS) -c $< -o $@

externals_all: $(externals_all_objs) Makefile
	$(F77) -o $@  $(FFLAGS) $(externals_all_objs) $(OTHERLIBS)


clean:
	rm -f *.o externals_all
