interface Task {
  taskId: string;
  taskName: string;
  deadline?: string; // ISO date string
  estimatedDuration?: number; // in hours
  workload?: { [date: string]: number }; // tanggal -> jam kerja
}

interface ComplianceResult {
  taskId: string;
  taskName: string;
  compliant: boolean;
  reasons: string[];
}

export function checkCompliance(schedule: Task[]): ComplianceResult[] {
  const results: ComplianceResult[] = [];

  for (const task of schedule) {
    const { taskId, taskName, deadline, estimatedDuration, workload } = task;
    const reasons: string[] = [];

    // 1. Cek apakah workload mencukupi estimasi
    const totalPlanned = workload
      ? Object.values(workload).reduce((a, b) => a + b, 0)
      : 0;

    if ((estimatedDuration ?? 0) > totalPlanned) {
      reasons.push(`Total planned hours (${totalPlanned}) less than estimated (${estimatedDuration})`);
    }

    // 2. Cek apakah deadline dilanggar
    if (deadline && workload) {
      const latestWorkDate = Object.keys(workload).sort().pop(); // tanggal terakhir
      if (latestWorkDate && new Date(latestWorkDate) > new Date(deadline)) {
        reasons.push(`Work planned beyond deadline (${latestWorkDate} > ${deadline})`);
      }
    }

    results.push({
      taskId,
      taskName,
      compliant: reasons.length === 0,
      reasons,
    });
  }

  return results;
}