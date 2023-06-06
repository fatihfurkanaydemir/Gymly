﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using UsersService.Infrastructure.Persistence.Contexts;

#nullable disable

namespace UsersService.Infrastructure.Persistence.Migrations
{
    [DbContext(typeof(UsersServiceDbContext))]
    [Migration("20230606131107_Initial")]
    partial class Initial
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.7")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("UsersService.Domain.Entities.TrainerWorkoutProgram", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Description")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("HeaderImageUrl")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("LastModified")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<double>("Price")
                        .HasColumnType("double precision");

                    b.Property<string>("ProgramDetails")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("TrainerSubjectId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int?>("UserId")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.HasIndex("UserId");

                    b.ToTable("TrainerWorkoutPrograms");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("AvatarUrl")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Diet")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int?>("EnrolledProgramId")
                        .HasColumnType("integer");

                    b.Property<string>("Gender")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<double>("Height")
                        .HasColumnType("double precision");

                    b.Property<DateTime>("LastModified")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("SubjectId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("Type")
                        .HasColumnType("integer");

                    b.Property<double>("Weight")
                        .HasColumnType("double precision");

                    b.HasKey("Id");

                    b.HasIndex("EnrolledProgramId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.UserWorkoutProgram", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("Content")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Description")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("LastModified")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int?>("UserId")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.HasIndex("UserId");

                    b.ToTable("UserWorkoutPrograms");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.Workout", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp with time zone");

                    b.Property<int>("DurationInMinutes")
                        .HasColumnType("integer");

                    b.Property<DateTime>("LastModified")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("ProgramContent")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ProgramDescription")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ProgramTitle")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("SubjectId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("Workouts");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.TrainerWorkoutProgram", b =>
                {
                    b.HasOne("UsersService.Domain.Entities.User", null)
                        .WithMany("TrainerWorkoutPrograms")
                        .HasForeignKey("UserId");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.User", b =>
                {
                    b.HasOne("UsersService.Domain.Entities.TrainerWorkoutProgram", "EnrolledProgram")
                        .WithMany("EnrolledUsers")
                        .HasForeignKey("EnrolledProgramId");

                    b.Navigation("EnrolledProgram");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.UserWorkoutProgram", b =>
                {
                    b.HasOne("UsersService.Domain.Entities.User", null)
                        .WithMany("UserWorkoutPrograms")
                        .HasForeignKey("UserId");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.TrainerWorkoutProgram", b =>
                {
                    b.Navigation("EnrolledUsers");
                });

            modelBuilder.Entity("UsersService.Domain.Entities.User", b =>
                {
                    b.Navigation("TrainerWorkoutPrograms");

                    b.Navigation("UserWorkoutPrograms");
                });
#pragma warning restore 612, 618
        }
    }
}
